import { Category } from '../entities/Category.entity'
import {
  Picture,
  PictureCreateInput,
  PictureUpdate,
} from '../entities/Picture.entity'
import { Repository } from 'typeorm'
import { validate } from 'class-validator'
import { dataSource } from '../datasource'
import { User } from '../entities/User.entity'
import Cookies from 'cookies'
import { Request, Response } from 'express'
import jwt from 'jsonwebtoken'

export class PictureService {
  db: Repository<Picture>

  constructor() {
    this.db = dataSource.getRepository(Picture)
  }

  async list() {
    const listPicture = this.db.find({ relations: ['category'] })
    return listPicture
  }

  async find(id: number) {
    const picture = await this.db.findOne({
      where: { id },
      relations: { category: true, updatedBy: true, createdBy: true },
    })

    if (!picture) {
      throw new Error(`Picture with ${id} not found`)
    }
    return picture
  }

  async createImage({
    name,
    mimetype,
    path,
    urlHD,
    urlMiniature,
    // type,
    // referenceId,
    context,
  }: PictureCreateInput & {
    context: { req: Request; res: Response }
  }) {
    const cookies = new Cookies(context.req, context.res)
    const renthub_token = cookies.get('renthub_token')

    if (!renthub_token) throw new Error('Not authenticated')
    let createdBy: User | null = null

    try {
      // Verify token
      const payload = jwt.verify(
        renthub_token,
        process.env.JWT_SECRET_KEY || ''
      )
      // Get user from payload
      if (typeof payload === 'object' && 'userId' in payload) {
        const user = await User.findOne({
          where: { id: payload.userId },
          relations: {
            role: true,
          },
        })
        createdBy = user
        if (createdBy?.role?.right !== 'ADMIN')
          throw new Error('User not found or is not authorised')
      }
    } catch (err) {
      console.error('Error verifying token:', err)
    }

    if (!createdBy) throw new Error('User not found')
    try {
      // relation for picture
      const relation = {}
      // if (referenceId) {
      //   Object.assign(relation, { [type]: { id: referenceId } })
      // }

      const picture = this.db.create({
        name,
        mimetype,
        path,
        urlHD,
        urlMiniature,
        createdBy,
        ...relation,
      })

      const pictureSave = await picture.save()
      return pictureSave
    } catch (error) {
      throw new Error('Error creating picture')
    }
  }

  async createOnCategory(
    pictureInput: PictureCreateInput,
    idCategory: number,
    user: User
  ) {
    const errors = await validate(pictureInput)

    if (errors.length > 0) {
      throw new Error('Validation failed!')
    }

    const CategoryExist = await dataSource.getRepository(Category).findOne({
      where: { id: idCategory },
    })
    if (!CategoryExist) {
      throw new Error(`Category with ID ${idCategory} not found`)
    }

    const newPicture = this.db.create({
      ...pictureInput,
      createdBy: user,
      category: CategoryExist,
    })
    await this.db.save(newPicture)
    return newPicture
  }

  async updateOnCategory(
    idPicture: number,
    pictureInput: PictureUpdate,
    user: User
  ) {
    const errors = await validate(pictureInput)

    if (errors.length > 0) {
      throw new Error('Validation failed!')
    }

    const pictureUpdate: Picture | null = await this.db.findOne({
      where: { id: +idPicture },
      relations: ['category'],
    })
    if (!pictureUpdate) {
      throw new Error(`Picture with ID ${idPicture} not found`)
    }
    const pictureToSave = this.db.merge(pictureUpdate, {
      ...pictureInput,
      updatedBy: user,
    })
    return await this.db.save(pictureToSave)
  }

  // delete picture do not delete category but remplacer pictureId by null
  // we dont need to delete category
  async deleteWithCategory(id: number) {
    const picture = await this.db.findOne({
      where: { id },
      relations: ['category'],
    })
    if (!picture) {
      throw new Error(`Picture with ${id} not found`)
    }
    if (picture?.category) {
      const category = await dataSource.getRepository(Category).findOne({
        where: { id: picture.category.id },
      })
      if (category) {
        Object.assign(category, { picture: null })
        await dataSource.getRepository(Category).save(category)
      }
    }

    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { affected } = await this.db.delete(picture.id)
    if (affected === 0) throw new Error('no delete affected on picture')
    return picture
  }
}
