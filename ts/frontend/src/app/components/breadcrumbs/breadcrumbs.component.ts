import { Component, inject } from '@angular/core'
import { Router, RouterModule } from '@angular/router'

@Component({
  selector: 'app-breadcrumbs',
  imports: [RouterModule],
  templateUrl: './breadcrumbs.component.html',
  styleUrl: './breadcrumbs.component.scss',
})
export class BreadcrumbsComponent {
  crumbs: string[] = []

  constructor() {
    const router = inject(Router)

    this.crumbs = router.routerState.snapshot.url.split('/').filter((c) => c)
  }

  getCrumbLink(index: number) {
    return ['/', ...this.crumbs.slice(0, index + 1)]
  }
}
