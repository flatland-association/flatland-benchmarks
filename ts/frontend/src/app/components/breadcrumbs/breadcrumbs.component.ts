import { Component, inject, OnDestroy, OnInit } from '@angular/core'
import { NavigationEnd, Router, RouterModule } from '@angular/router'
import { filter, Subscription } from 'rxjs'
import { ResourceService } from '../../features/resource/resource.service'

interface Breadcrumb {
  label: string
  link: string[]
}

export interface BreadcrumbData {
  breadcrumbs: (symbol | string)[]
}

// implementation needs do be done in class BreadcrumbsComponent
export const Breadcrumb = {
  EXACT: Symbol(),
  HIDDEN: Symbol(),
  benchmark_group: Symbol(),
}

// resolvers are async functions that either return
// - a string to be displayed
// - `null` to hide the breadcrumb entirely
type BreadcrumbNameResolvers = Record<symbol, (segment: string) => Promise<string | null>>

@Component({
  selector: 'app-breadcrumbs',
  imports: [RouterModule],
  templateUrl: './breadcrumbs.component.html',
  styleUrl: './breadcrumbs.component.scss',
})
export class BreadcrumbsComponent implements OnInit, OnDestroy {
  private resourceService = inject(ResourceService)
  private router = inject(Router)
  private routerSubscription?: Subscription

  breadcrumbs: Breadcrumb[] = []

  ngOnInit(): void {
    this.routerSubscription = this.router.events
      .pipe(filter((event) => event instanceof NavigationEnd))
      .subscribe(() => {
        this.buildBreadcrumbs()
      })
  }

  ngOnDestroy(): void {
    this.routerSubscription?.unsubscribe()
  }

  private buildBreadcrumbs() {
    // traverse the url tree (*) to collect segments and crumbs definitions
    const segments: string[] = []
    const breadcrumbNames: BreadcrumbData['breadcrumbs'] = []
    let urlGroup = this.router.routerState.snapshot.root
    while (urlGroup) {
      segments.push(...urlGroup.url.map((url) => url.path).filter((s) => s))
      breadcrumbNames.push(...((urlGroup.data as BreadcrumbData)['breadcrumbs'] ?? []))
      // * traverse primary outlet only (hence the [0])
      urlGroup = urlGroup.children[0]
    }
    // resolve all names in parallel
    Promise.all(
      segments.map((segment, index) => {
        const name = breadcrumbNames[index]
        if (typeof name === 'string') {
          return name
        }
        const resolver = this.breadcrumbNameResolvers[name] ?? this.breadcrumbNameResolvers[Breadcrumb.HIDDEN]
        return resolver(segment)
      }),
    ).then((names) => {
      //... once done, update breadcrumbs
      this.breadcrumbs = segments
        .map((segment, index) => {
          const name = names[index]
          if (name === null) {
            return undefined
          } else {
            return {
              label: name,
              link: ['/', ...segments.slice(0, index + 1)],
            }
          }
        })
        .filter((c) => !!c)
    })
  }

  // ---
  // Implementation of name resolvers

  breadcrumbNameResolvers: BreadcrumbNameResolvers = {
    [Breadcrumb.EXACT]: async (segment: string) => segment,
    [Breadcrumb.HIDDEN]: async (_segment: string) => null,
    [Breadcrumb.benchmark_group]: async (segment: string) => {
      const group = (
        await this.resourceService.load('/definitions/benchmark-groups/:group_ids', { params: { group_ids: segment } })
      )?.at(0)
      // return resource name, fall back to uuid[0...8]
      return group?.name ?? segment.slice(0, 8)
    },
  }
}
