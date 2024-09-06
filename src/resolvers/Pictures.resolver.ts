import {
  Resolver,
  Mutation,
  Arg,
  Ctx,
  ID,
  Authorized,
  Query,
} from 'type-graphql'
import {
  Picture,
  PictureCreateInput,
  PictureUpdate,
} from '../entities/Picture.entity'
import { PictureService } from '../services/Picture.service'
import { MyContext } from '../types/Context.type'

@Resolver(Picture)
export class PictureResolver {
  @Query(() => Picture)
  async findPictureOnCategory(@Arg('idCategory', () => ID) idCategory: number) {
    const pictureById = await new PictureService().find(+idCategory)
    return pictureById
  }

  @Authorized('ADMIN')
  @Mutation(() => Picture)
  async createPictureOnCategory(
    @Ctx() context: MyContext,
    @Arg('data', () => PictureCreateInput) data: PictureCreateInput,
    @Arg('idCategory', () => ID) idCategory: number
  ) {
    if (!context.user) {
      throw new Error('Not authenticated')
    }
    const newPicture = await new PictureService().createOnCategory(
      data,
      idCategory,
      context.user
    )

    return newPicture
  }

  @Authorized('ADMIN')
  @Mutation(() => Picture)
  async updatePictureOnCategory(
    @Ctx() context: MyContext,
    @Arg('idPicture', () => ID) idPicture: number,
    @Arg('dataPicture', () => PictureUpdate) data: PictureUpdate
  ) {
    if (!context.user) {
      throw new Error('Not authenticated')
    }

    return await new PictureService().updateOnCategory(
      idPicture,
      data,
      context.user
    )
  }
  // @TODO: suppression du code sur la featured multer ( accessible dans le commit )
  @Authorized('ADMIN')
  @Mutation(() => Picture, { nullable: true })
  async deletePicture(
    @Ctx() context: MyContext,
    @Arg('idPicture', () => ID) idPicture: number
  ) {
    if (!context.user) {
      throw new Error('Not authenticated')
    }

    return new PictureService().deleteWithCategory(idPicture)
  }
}
