import * as Minio from 'minio'
// https://github.com/minio/minio-js/issues/1394
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { Service } from './service.mjs'

const logger = new Logger('minio')

/**
 * Service class providing common MinIO / S3 functionality.
 */
export class MinioService extends Service {
  minioClient: Minio.Client

  constructor(config: configuration) {
    super(config)

    // apparently MinIO clients are created once and kept around
    // (http agent is created on-demand internally)
    this.minioClient = new Minio.Client({
      endPoint: config.minio.host,
      port: config.minio.port,
      useSSL: config.minio.protocol === 'https://',
      accessKey: config.minio.user,
      secretKey: config.minio.password,
    })
  }

  async getFileStat(filename: string) {
    const path = `${this.config.minio.path}/${filename}`
    const stat = await this.minioClient.statObject(this.config.minio.bucket, path).catch((err) => {
      logger.error(['getFileStat', path, err.message])
      return undefined
    })
    return stat
  }

  async getFileContents(filename: string): Promise<string | undefined> {
    const path = `${this.config.minio.path}/${filename}`
    const contents = await new Promise<string | undefined>((resolve, reject) => {
      this.minioClient.getObject(this.config.minio.bucket, path).then((stream) => {
        let contents = ''
        stream.setEncoding('utf8')
        stream.on('data', (chunk) => {
          contents += chunk
        })
        stream.on('end', () => {
          resolve(contents)
        })
        stream.on('error', (err) => {
          reject(err)
        })
      })
    }).catch((err) => {
      logger.error(['getFileContents', path, err.message])
      return undefined
    })
    return contents
  }
}
