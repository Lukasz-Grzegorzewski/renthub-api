import fs from 'fs'
import path from 'path'

export const copyFile = (src: string, dest: string) => {
  return new Promise((resolve, reject) => {
    const dir = path.dirname(dest)

    // Ensure the destination directory exists
    fs.mkdir(dir, { recursive: true }, (err) => {
      if (err) {
        return reject(err)
      }

      const readStream = fs.createReadStream(src)
      const writeStream = fs.createWriteStream(dest)

      readStream.on('error', reject)
      writeStream.on('error', reject)
      writeStream.on('finish', resolve)

      readStream.pipe(writeStream)
    })
  })
}
