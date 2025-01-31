import { configuration } from '../config/config.mjs'

/**
 * Base class for services. Provides common ground for service initialization
 * and access patterns.
 */
export class Service {
  // This is just for type hints, the property will be added to the child class
  // in create() - otherwise all child classes would share the value.
  static instances: Map<string, Service>

  // Because this (that) is a static function, `this` (this) is of type
  // `typeof Service` (the class), not simply `Service` (the instance).
  /**
   * Create a service instance with the given configuration.
   * @param this `this` argument. You do not need to pass this, it's inferred from property access.
   * @param config Configuration object passed to the service implementation.
   * @param ident Identifier for the instance. Optional, defaults to `default`.
   */
  static create<T extends typeof Service>(this: T, config: configuration, ident = 'default') {
    const service = new this(config)
    this.instances = new Map<string, InstanceType<T>>()
    this.instances.set(ident, service)
  }

  // default is always available
  /**
   * Returns a previously constructed instance of implemented `Service`.
   * @returns Default `Service` implementation instance.
   */
  static getInstance<T extends typeof Service>(this: T): InstanceType<T>
  //... others might not necessarily be
  /**
   * Returns a previously constructed instance of implemented `Service`.
   * @param ident Instance identifier.
   * @returns A `Service` implementation instance or `undefined` when an un-constructed instance was requested.
   */
  static getInstance<T extends typeof Service>(this: T, ident: string): InstanceType<T> | undefined

  static getInstance<T extends typeof Service>(this: T, ident = 'default') {
    return this.instances.get(ident)
  }

  /**
   * The configuration object that was passed for this service's creation.
   */
  config: configuration

  /**
   * `Service` constructor. In your implementation, you need to take `config`
   * and pass it to `super()` in order to have it accessible during
   * construction.
   * @param config Configuration object passed to the service implementation.
   */
  constructor(config: configuration) {
    this.config = config
  }
}
