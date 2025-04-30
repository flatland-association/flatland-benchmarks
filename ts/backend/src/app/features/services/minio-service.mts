import * as Minio from 'minio'
// https://github.com/minio/minio-js/issues/1394
import { UploadedObjectInfo } from '../../../../../../node_modules/minio/dist/esm/internal/type.mjs'
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

  /**
   * Returns stat information of an object. To check if a file exists, call
   * with `probing` set to `true` (see footnote).
   * @param filename File name of object to stat.
   * @param probing If `true`, objects not found won't raise an error.
   * @returns `Minio.BucketItemStat` or `undefined` in case of error.
   * @see `statObject` as the idiomatic way to check if object exists {@link https://github.com/minio/minio-go/issues/1082}
   */
  async getFileStat(filename: string, probing = false) {
    const path = `${this.config.minio.path}/${filename}`
    const stat = await this.minioClient.statObject(this.config.minio.bucket, path).catch((err: Minio.S3Error) => {
      // if probing, NotFound errors are not treated as error
      if (!(probing && err.code === 'NotFound')) {
        logger.error(['getFileStat', path, err.message])
      }
      return undefined
    })
    return stat
  }

  /**
   * Returns contents of an object.
   * @param filename File name of object to get.
   * @returns Contents as `string` or `undefined` in case of error.
   */
  async getFileContents(filename: string): Promise<string | undefined> {
    const path = `${this.config.minio.path}/${filename}`
    // wrap in new promise i.o.t. be able to await "on end"
    const contents = await new Promise<string | undefined>((resolve, reject) => {
      this.minioClient
        .getObject(this.config.minio.bucket, path)
        .then((stream) => {
          let contents = ''
          stream.setEncoding('utf8')
          stream.on('data', (chunk) => {
            contents += chunk
          })
          stream.on('end', () => {
            resolve(contents)
          })
          // catch stream errors and reject
          stream.on('error', (err) => {
            reject(err)
          })
        })
        // catch `getObject` errors and reject
        .catch((err: Minio.S3Error) => {
          reject(err)
        })
    })
      // catch all, report and typed return (explicit undefined)
      .catch((err: Error | Minio.S3Error) => {
        logger.error(['getFileContents', path, err.message])
        return undefined
      })
    return contents
  }

  /**
   * Uploads file contents.
   * @param filename File name of object to create.
   * @param contents Contents to upload.
   * @returns `UploadedObjectInfo` or `undefined` in case of error.
   */
  async putFileContents(filename: string, contents: string): Promise<UploadedObjectInfo | undefined> {
    const path = `${this.config.minio.path}/${filename}`
    const info = await this.minioClient
      .putObject(this.config.minio.bucket, path, contents)
      .catch((err: Minio.S3Error) => {
        logger.error(['putFileContents', path, err.message])
        return undefined
      })
    return info
  }
}
