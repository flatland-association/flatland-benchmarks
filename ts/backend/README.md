# FAB Backend

This backend is a Node.js module. The module creates a server application publishing a REST API and communicating via AMQP 0.9.1 messages with an AMQP server (i.e. RabbitMQ).

## Configuration

The configuration template is found at `ts/backend/src/config/config.jsonc`. It's a JSON file with comments describing the sections.

Furthermore, run-time behavior can be controlled using command-line arguments when executing `main.min.mjs`:

```terminal
              --help, -h  Print this message.

             --log-level  Set log output level.
                    type  ALL | TRACE | DEBUG | INFO | WARN | ERROR | FATAL |
                          OFF
                 default  INFO

             --log-stack  Include logging source (method and file path) in log.
                    type  false | <any other value>
                 default  false

          --log-colorful  Enable colorful terminal output for log.
                    type  false | <any other value>
                 default  false

         --log-stringify  Output log messages as stringified JSON.
                    type  false | <any other value>
                 default  false
```

## Development server

To start a local development server, run the following command in `ts/backend`:

```bash
npm run start.ai4realnet
npm run start.fab
```

This will:
* compile the source code to a JavaScript module output to `out-tsc/backend/app`
* copy (non-overwriting) the `config.jsonc` to `out-tsc/backend/config` for your convenience
* start the app in Node.js
* start unit tests (in watch mode) in parallel

The server isn't live-updated. To reflect any changes made to the source code, `npm start` has to be run again.

The script will only write the output `config.jsonc` once. This allows you have a local configuration that differs from the template's. To get new template properties to your local `config.jsonc`, you'll either have to copy them manually or delete the file and let it be re-created from template by the script.

## Code scaffolding

There are no CLI code scaffolding tools for FAB Backend. Manually create `.mts` files in **sub-folders** within `src/app/features/` for maximum clarity.

> No type infix is used. This is because one file could hold a mixture of feature types, especially when circular imports couldn't be prevented otherwise.

## Deploy

* In `ts/backend`, run:

  ```bash
  npm run build
  ```

  This will:
  * compile the source code to a JavaScript module output to `dist/backend/app`
  * create an empty folder `dist/backend/config` for your convenience
  * create an empty folder `dist/backend/public` for your convenience
* Upload `dist/backend` to web server (e.g. nginx)
* Manually copy `config/config.jsonc` (first time only) and modify according to your needs. The template is `ts/backend/src/config/config.jsonc`. It's not copied over automatically to ensure the config template won't overwrite the user-specified configs.
* Manually copy customization data to `public`. The template is `ts/backend/src/public/*`. It's not copied over automatically to ensure the customization template won't overwrite deployment-specific customizations.

* Set up your server to execute `node main.min.mjs` in `app/` (intentionally leaving out further instructions, since this depends on the server in use)
