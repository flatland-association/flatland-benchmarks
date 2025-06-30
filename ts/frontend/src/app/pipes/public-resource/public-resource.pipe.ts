import { Pipe, PipeTransform } from '@angular/core'
import { environment } from '../../../environments/environment'

@Pipe({
  name: 'publicResource',
})
/**
 * URL transformer for resources that are publicly served from backend.
 */
export class PublicResourcePipe implements PipeTransform {
  transform<T extends string | null | undefined>(value: T, ..._args: unknown[]): T {
    if (!value) return value
    return (environment.apiBase + '/public/' + value) as T
  }
}
