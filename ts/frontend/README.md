# FAB Frontend

This project is an Angular web application. It was generated using [Angular CLI](https://github.com/angular/angular-cli) version 19.0.2.

## Development server

To start a local development server, run the following command in `ts/frontend`:

```bash
ng serve
```

Once the server is running, open your browser and navigate to `http://localhost:4200/`. The application will automatically reload whenever you modify any of the source files.

## Code scaffolding

Angular CLI includes powerful code scaffolding tools. To use them, run the following `ng` commands in the workspace root:

### Components

```bash
ng generate component components/<component-name>
```

This will generate a new component in `src/app/components/<component-name>/`. For reasons of clarity about what component selectors are in use, generate all components in `components` unless you use another prefix.

### Views

```bash
ng generate component views/<view-name> --type=view --prefix=view
```

This will generate a new component in `src/app/components/<component-name>/` with a `.view` type infix and a `view-` selector prefix. For reasons of clarity about what view selectors are in use, generate all views in `views`.

### Services

```bash
ng generate service features/<service-name>
```

This will generate a new service in `src/app/features/<service-name>/`. The reason behind having a folder per service in `features` is to have a place where public interfaces and classes belonging to that service can be put. Also, `features` is the directory for everything that's not a component, view, directive or pipe.

If you wish to generate a service at another specified path, include the path and the `--flat=true` option.

### Directives

```bash
ng generate directive directives/<directive-name>
```

This will generate a new directive in `src/app/directives/<directive-name>/`. For reasons of clarity about what directive selectors are in use, generate all directives in `directives`.

### Pipes

```bash
ng generate pipe pipes/<pipe-name>
```

This will generate a new pipe in `src/app/pipes/<pipe-name>/`. For reasons of clarity about what pipe selectors are in use, generate all pipes in `pipes`.

### Classes, Interfaces etc.

For other schematics (i.e. `class`, `interface`, `enum`), the `flat` option defaults to `false`, meaning they can be generated e.g. like:

```bash
ng generate <schematics> features/<feature>/<feature-name>
```

`features` is the directory for everything that's not a component, view, directive or pipe.

For a complete list of available schematics:

```bash
ng generate --help
```

For other features without provided schematics (i.e. `type`, `const`, `function`), create the `.ts` file manually.

For these kinds of features, no type infix is used. This is because one file could hold a mixture of feature types, especially when circular imports couldn't be prevented otherwise.


## Building

To build the project, run the following command in `ts/frontend`:

```bash
ng build
```

This will compile your project and store the build artifacts in the `dist/` directory. By default, the production build optimizes your application for performance and speed.

## Additional Resources

For more information on using the Angular CLI, including detailed command references, visit the [Angular CLI Overview and Command Reference](https://angular.dev/tools/cli) page.
