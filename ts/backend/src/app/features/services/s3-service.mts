import * as AWS from '@aws-sdk/client-s3'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { Service } from './service.mjs'

const logger = new Logger('s3')

/**
 * Service class providing common S3 functionality.
 */
export class S3Service extends Service {
  s3Client: AWS.S3

  /**
   * Error that occured during a command.
   * Is reset to `undefined` upon invoking any of the commands.
   */
  error?: Error

  constructor(config: configuration) {
    super(config)

    this.s3Client = new AWS.S3({
      // S3 requires region, but apparently specified region doesn't matter if
      // there's only one region defined in backend.
      region: config.s3.region,
      endpoint: `${config.s3.protocol}${config.s3.host}:${config.s3.port}`,
      credentials: {
        accessKeyId: config.s3.user,
        secretAccessKey: config.s3.password,
      },
      forcePathStyle: true,
    })
  }

  /**
   * Returns stat information of an object. To check if a file exists, call
   * with `probing` set to `true` (see footnote).
   * @param filename File name of object to stat.
   * @param probing If `true`, objects not found won't raise an error.
   * @returns `AWS.HeadObjectCommandOutput` or `undefined` in case of error.
   */
  async getFileStat(filename: string, probing = false) {
    this.error = undefined
    const path = `${this.config.s3.path}/${filename}`
    const stat = await this.s3Client.headObject({ Bucket: this.config.s3.bucket, Key: path }).catch((err: Error) => {
      // if probing, NotFound errors are not treated as error
      if (!(probing && err instanceof AWS.NotFound)) {
        this.error = err
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
    this.error = undefined
    const path = `${this.config.s3.path}/${filename}`
    const contentStream = await this.s3Client
      .getObject({ Bucket: this.config.s3.bucket, Key: path })
      .then((output) => output.Body)
      .catch((err: Error) => {
        this.error = err
        logger.error(['getFileContents', path, err.message])
        return undefined
      })
    if (contentStream) {
      return await contentStream.transformToString('utf-8')
    }
    return undefined
  }

  /**
   * Uploads file contents.
   * @param filename File name of object to create.
   * @param contents Contents to upload.
   * @returns `AWS.PutObjectCommandOutput` or `undefined` in case of error.
   */
  async putFileContents(filename: string, contents: string): Promise<AWS.PutObjectCommandOutput | undefined> {
    this.error = undefined
    const path = `${this.config.s3.path}/${filename}`
    const info = await this.s3Client
      .putObject({ Bucket: this.config.s3.bucket, Key: path, Body: contents })
      .catch((err: Error) => {
        this.error = undefined
        logger.error(['putFileContents', path, err.message])
        return undefined
      })
    return info
  }
}
