import { ApiEndpointsOfVerb, ApiGetEndpoints, ApiPatchEndpoints, ApiPostEndpoints } from '@common/api-endpoints.js'
import { ApiResponse } from '@common/api-response.js'
import express, { NextFunction, Request, Response, Router } from 'express'
import type { RouteParameters } from 'express-serve-static-core'
import { ReasonPhrases, StatusCodes } from 'http-status-codes'
import { configuration } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { failedPresenceCheck, presenceCheckTrusted } from './controller-utils.mjs'

const logger = new Logger('controller')

/**
 * Type for handlers for given method.
 */
export type HandlerOfVerb<V extends string, E extends keyof ApiEndpointsOfVerb<V>> = (
  req: Request<
    // allows inferring ":parameters"
    RouteParameters<E>,
    // unknown, due to chaining
    unknown,
    // type of request body and query taken from ApiEndpointDefinitions
    ApiEndpointsOfVerb<V>[E]['request']['body'],
    ApiEndpointsOfVerb<V>[E]['request']['query']
  >,
  res: Response<ApiEndpointsOfVerb<V>[E]['response']>,
  next: NextFunction,
) => void | Promise<void>

/**
 * Type for GET handlers.
 */
export type GetHandler<E extends keyof ApiGetEndpoints> = HandlerOfVerb<'GET', E>

/**
 * Type for POST handlers.
 */
export type PostHandler<E extends keyof ApiPostEndpoints> = HandlerOfVerb<'POST', E>

/**
 * Type for PATCH handlers.
 */
export type PatchHandler<E extends keyof ApiPatchEndpoints> = HandlerOfVerb<'PATCH', E>

/**
 * Base class for controllers.
 * In your child class, attach handlers using `attach<Verb>` methods in the
 * constructor.
 */
export class Controller {
  /** Router object to pass in `express.use` */
  router: Router

  constructor(public config: configuration) {
    this.router = express.Router()
  }

  /**
   * Send a well-typed JSON response with optional debug info.
   * @param req Express request.
   * @param res Express response.
   * @param body Response body. Type is derived from endpoint registry.
   * @param dbg Additional debug info.
   * @param status HTTP status code (default 200 - OK).
   * @see {@link ApiResponse}
   */
  respond<T>(req: Request, res: Response<ApiResponse<T>>, body: T, dbg?: unknown, status = StatusCodes.OK) {
    res.status(status)
    res.json({
      body,
      dbg,
    })
    logger.debug(`${req.method} ${req.originalUrl}: Response ${status}`, body)
  }

  /**
   * Send a well-typed JSON error response with optional debug info.
   * @param req Express request.
   * @param res Express response.
   * @param error Error object.
   * @param body Response body. Type is derived from endpoint registry.
   * @param dbg Additional debug info.
   * @param status HTTP status code (default 500 - Internal Server Error).
   * @see {@link ApiResponse}
   */
  respondError<T>(
    req: Request,
    res: Response<ApiResponse<T>>,
    error: ApiResponse<T>['error'],
    body?: T,
    dbg?: unknown,
    status = StatusCodes.INTERNAL_SERVER_ERROR,
  ) {
    res.status(status)
    res.json({
      body,
      error,
      dbg,
    })
    logger.debug(`${req.method} ${req.originalUrl}: Error response ${status}`, error, body)
  }

  /**
   * Send a well-typed error with code 401 (Unauthorized), additional
   * error text and optional debug info.
   * @param req Express request.
   * @param res Express response.
   * @param error Error object.
   * @param body Response body. Type is derived from endpoint registry.
   * @param dbg Additional debug info.
   * @see {@link ApiResponse}
   */
  unauthorizedError<T>(
    req: Request,
    res: Response<ApiResponse<T>>,
    error: ApiResponse<T>['error'],
    body?: T,
    dbg?: unknown,
  ) {
    res.status(StatusCodes.UNAUTHORIZED)
    res.json({
      body,
      error,
      dbg,
    })
    logger.warn(`${req.method} ${req.originalUrl}: Unauthorized ${StatusCodes.UNAUTHORIZED}`, error)
  }

  /**
   * Performs a presence check and responds with `OK` if that passed and error
   * responds with `Not Found` with the missed ids in `dbg` otherwise.
   * @param req Express request.
   * @param res Express response.
   * @param body Response body. Type is derived from endpoint registry.
   * @param ids Ids to look for.
   * @param idProperty Property name in `body` items to compare with id.
   */
  respondAfterPresenceCheck<T extends unknown[], K extends keyof T[number]>(
    req: Request,
    res: Response<ApiResponse<T>>,
    body: T,
    ids: T[number][K][],
    idProperty: K = 'id' as K,
  ) {
    if (presenceCheckTrusted(body, ids, idProperty)) {
      this.respond(req, res, body)
    } else {
      this.respondError(
        req,
        res,
        { text: ReasonPhrases.NOT_FOUND },
        body,
        failedPresenceCheck(body, ids, idProperty),
        StatusCodes.NOT_FOUND,
      )
    }
  }

  // Attach handler wrapper, serves two purposes:
  // 1. Provides a common try catch wrap around the handler.
  // 2. Allows type inferring from route (Express' types are too convoluted to
  //    be overriden by declares IMHO).
  private attach<V extends 'get' | 'post' | 'patch', E extends keyof ApiEndpointsOfVerb<Uppercase<V>>>(
    verb: V,
    endpoint: E,
    handler: HandlerOfVerb<Uppercase<V>, E>,
  ) {
    this.router[verb](endpoint, async (req, res, next) => {
      try {
        logger.debug(`${req.method} ${req.originalUrl}: Request`, req.body)
        await handler(req, res, next)
        // force a server error if the handler did not respond
        if (!res.writableEnded) {
          logger.error(`${req.method} ${req.originalUrl}: Handler did not respond.`)
          next('Handler did not respond')
        }
      } catch (error) {
        logger.error(`${req.method} ${req.originalUrl}: Exception`, error)
        next(error)
      }
    })
  }

  /**
   * Attach handler for GET endpoint.
   */
  attachGet<E extends keyof ApiGetEndpoints>(endpoint: E, handler: GetHandler<E>) {
    this.attach('get', endpoint, handler)
  }

  /**
   * Attach handler for POST endpoint.
   */
  attachPost<E extends keyof ApiPostEndpoints>(endpoint: E, handler: PostHandler<E>) {
    this.attach('post', endpoint, handler)
  }

  /**
   * Attach handler for PATCH endpoint.
   */
  attachPatch<E extends keyof ApiPatchEndpoints>(endpoint: E, handler: PatchHandler<E>) {
    this.attach('patch', endpoint, handler)
  }
}

/**
 * Returns a short recap of requested endpoint (method + url) for logging.
 */
export function dbgRequestEndpoint(req: Request) {
  return `${req.method} ${req.url}`
}

/**
 * Returns an object based off Request reduced to the valuable information.
 */
export function dbgRequestObject(req: Request) {
  return {
    // full request URL (e.g. /mirror/1?test=2&tester=3)
    url: req.url,
    // query params (e.g. {test: 2, tester: 3})
    query: req.query,
    // path (e.g. /mirror/1)
    path: req.path,
    // params (e.g. {id: 1})
    params: req.params,
    // body (JSON, e.g. when POST requesting)
    body: req.body,
  }
}
