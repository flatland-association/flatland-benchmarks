import { configuration } from '../config/config.mjs'
import { CeleryService } from '../services/celery-client-service.mjs'
import { AuthService } from '../services/auth-service.mjs'
import { Controller, dbgRequestObject, GetHandler, PatchHandler, PostHandler } from './controller.mjs'
import { Logger } from '../logger/logger.mjs'

const logger = new Logger('debug-controller')

export class DebugController extends Controller {
  constructor(config: configuration) {
    super(config)

    this.attachGet('/mirror', this.getMirror)
    this.attachGet('/mirror/:id', this.getMirrorById)
    this.attachPost('/mirror', this.postMirror)
    this.attachPatch('/mirror/:id', this.patchMirrorById)
    this.attachGet('/health', this.celeryReady)
    this.attachGet('/whoami', this.getWhoami)
  }

  getMirror: GetHandler<'/mirror'> = (req, res) => {
    this.respond(res, 'This is the /mirror endpoint', dbgRequestObject(req))
  }

  getMirrorById: GetHandler<'/mirror/:id'> = (req, res) => {
    this.respond(res, 'This is the /mirror/:id endpoint', dbgRequestObject(req))
  }

  postMirror: PostHandler<'/mirror'> = (req, res) => {
    // do not set body.data to see `requestError` in action
    // do not set body at all to see fallback error handling in action
    if (!req.body.data) {
      this.requestError(res, { text: 'No data set in request body' })
      return
    } else {
      this.respond(res, req.body, dbgRequestObject(req))
    }
  }

  patchMirrorById: PatchHandler<'/mirror/:id'> = (req, res) => {
    this.respond(res, { data: 'This is the PATCH /mirror/:id endpoint' }, dbgRequestObject(req))
  }

  // Posts a message to amqp queue using Celery client
  celeryReady: PostHandler<'/health'> = async (req, res) => {
    // send message to debug queue
    const amqp = CeleryService.getInstance()
    const sent = amqp.isReady();
    await withTimeout(sent,3000)
    .then(result => {
        logger.info(`Received result from queue:${result}`);
        this.respond(res, "ready", dbgRequestObject(req));
      })
    .catch(function (err) {
      logger.error(`Received error from queue:${err}`);
      if(err.message == "Timeout"){
        res.status(504)
        res.json({ "error": err.message })
        return
      }
      if(err.message.includes("ECONNREFUSED")){
        res.status(504)
        res.json({ "error": err.message })
        return
      }
      this.serverError(res, err)
    });

  }

  getWhoami: GetHandler<'/whoami'> = async (req, res) => {
    const auth = AuthService.getInstance()
    auth
      .authorization(req)
      .then((jwtp) => {
        const iam = jwtp
          ? {
              id: jwtp.sub,
              email: jwtp['email'],
              name: jwtp['name'],
            }
          : null
        this.respond(res, iam, jwtp)
      })
      .catch((err) => {
        this.serverError(res, err)
      })
  }
}

// https://javascript.plainenglish.io/implementing-timeouts-for-javascript-promises-25e03102df29
function withTimeout(promise, timeout) {
  return Promise.race([
    promise,
    new Promise((_, reject) => setTimeout(() => reject(new Error('Timeout')), timeout))
  ]);
}
