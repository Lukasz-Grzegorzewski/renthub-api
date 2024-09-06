import express from 'express'
import multer from 'multer'
import path from 'path'
import fs, { promises as fsPromises } from 'fs'
import sharp from 'sharp'
import { copyFile } from '../copyFile'
import { v4 as uuidv4 } from 'uuid'
import { PictureService } from '../../services/Picture.service'
import { Picture, RelationType } from '../../entities/Picture.entity'
import { replaceSpacesWith_ } from '../utils'

const tempStoragePath = '/app/public/temp'
const storagePath = '/app/public'


// Temp storage for uploaded files
const tempStorage = multer.diskStorage({
  destination: (
    req: express.Request,
    file: Express.Multer.File,
    cb: (error: Error | null, destination: string) => void
  ) => {
    fs.mkdirSync(tempStoragePath, { recursive: true })
    cb(null, tempStoragePath)
  },
  filename: (
    req: express.Request,
    file: Express.Multer.File,
    cb: (error: Error | null, filename: string) => void
  ) => {
    cb(null, file.originalname)
  },
})

export const uploadPicture = multer({ storage: tempStorage })

// Process the uploaded image
export const processImage = async (
  req: express.Request,
  res: express.Response
) => {
  const type: RelationType = req.body.type
  // const referenceId: number | undefined = req.body.referenceId

  if (req.file) {
    try {
      const { originalname } = req.file
      const ext = path.extname(originalname)
      const filenameNoExtNoSpaces = replaceSpacesWith_(
        path.parse(originalname).name
      )

      const finalStoragePath = path.join(storagePath, 'images', type || '')
      if (type && !fs.existsSync(finalStoragePath)) {
        fs.mkdirSync(finalStoragePath, { recursive: true })
      }

      // get the path of the temp file
      const tempFilePath = path.join(tempStoragePath, originalname)
      // generate new filenames for the HD and Miniature images
      const newFilenameHD = `${type}-${filenameNoExtNoSpaces}-HD-$${Date.now()}-${uuidv4()}${ext}`
      const newFilenameMini = `${type}-${filenameNoExtNoSpaces}-Mini-$${Date.now()}-${uuidv4()}${ext}`

      // get the final path of the file
      const finalFilePathHD = path.join(finalStoragePath, newFilenameHD)
      const finalFilePathMini = path.join(finalStoragePath, newFilenameMini)

      const image = sharp(tempFilePath)
      const metadata = await image.metadata()

      await image
        .resize(100, 100, {
          fit: 'contain',
          background: { r: 255, g: 255, b: 255, alpha: 0 },
        })
        .toFile(finalFilePathMini)

      if (
        (metadata.width && metadata.width > 1280) ||
        (metadata.height && metadata.height > 1280)
      ) {
        await image
          .resize(1280, 1280, { fit: 'contain' })
          .toFile(finalFilePathHD)
      } else await copyFile(tempFilePath, finalFilePathHD)

      // Delete the temp file
      if (fs.existsSync(tempFilePath)) {
        await fs.promises.unlink(tempFilePath)
      }

      const pathToFile = `/images${type ? '/' + type : ''}`
      const { mimetype } = req.file
      const picture = await new PictureService().createImage({
        name: filenameNoExtNoSpaces,
        mimetype: mimetype,
        path: `${pathToFile}`,
        urlHD: `${pathToFile}/${newFilenameHD}`,
        urlMiniature: `${pathToFile}/${newFilenameMini}`,
        // type,
        // referenceId,
        context: { req, res },
      })

      res.json({ pictureId: picture.id })
    } catch (error) {
      console.error('Error processing image:', error)
      res.status(500).send('Error processing image')
    }
  } else {
    res.status(400).send('No file was uploaded.')
  }
}

export async function deletePicture(pictureId: number) {
  const picture = await Picture.findOneBy({ id: pictureId })

  if (picture) {
    try {
      await Picture.remove(picture)

      const filePathHD = path.resolve(
        __dirname,
        `../../../public/${picture.urlHD}`
      )
      await fsPromises.unlink(filePathHD)
      const filePathMini = path.resolve(
        __dirname,
        `../../../public/${picture.urlMiniature}`
      )
      await fsPromises.unlink(filePathMini)
    } catch (error) {
      if ((error as NodeJS.ErrnoException).code === 'ENOENT') {
        console.error(
          `User delete : File not found: for picture id => ${pictureId} of user id => ${picture.user.id}`
        )
      } else {
        console.error('Error removing picture', error)
        throw new Error('Error removing picture')
      }
    }
  } else {
    throw new Error('Picture not found')
  }
}
