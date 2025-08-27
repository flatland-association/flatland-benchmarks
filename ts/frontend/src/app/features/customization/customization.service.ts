import { HttpClient } from '@angular/common/http'
import { inject, Injectable } from '@angular/core'
import { firstValueFrom } from 'rxjs'
import { environment } from '../../../environments/environment'

export type Setup = 'benchmark' | 'campaign'

// Type faith: We're currently unable to enforce that schema on
// customization.json, but we strongly believe the .json validates against
// this interface.
export interface Customization {
  setup: Setup
  content: {
    title: string
    logo?: string
    home: {
      lead: string
      benchmarksHeading: string
    }
    vcCampaign?: {
      lead: string
    }
    vcEvaluationObjective?: {
      lead: string
    }
    vcKpi?: {
      lead: string
    }
  }
}

@Injectable({
  providedIn: 'root',
})
export class CustomizationService {
  private http = inject(HttpClient)
  private customization?: Customization
  private customizationPromise?: Promise<Customization>

  /**
   * Asynchronously returns the file contents of `customization.json`.
   * If available, it returns the already cached object. Otherwise the file is
   * loaded from server.
   */
  getCustomization() {
    // customization already loading, do not re-trigger loading
    if (this.customizationPromise) return this.customizationPromise
    // customization already loaded, return
    if (this.customization) return Promise.resolve(this.customization)
    // no customization loaded, load
    this.customizationPromise = firstValueFrom(
      this.http.get<Customization>(`${environment.apiBase}/public/customization.json`),
    )
    return this.customizationPromise
  }
}
