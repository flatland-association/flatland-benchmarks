import { Component, OnInit, inject } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute, RouterModule } from '@angular/router'
import { BenchmarkDefinitionRow, SubmissionRow } from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { LeaderboardComponent } from '../../components/leaderboard/leaderboard.component'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-benchmarks-detail',
  imports: [FormsModule, RouterModule, ContentComponent, SectionComponent, BreadcrumbsComponent, LeaderboardComponent],
  templateUrl: './benchmarks-detail.view.html',
  styleUrl: './benchmarks-detail.view.scss',
})
export class BenchmarksDetailView implements OnInit {
  apiService = inject(ApiService)

  id: string
  benchmark?: BenchmarkDefinitionRow
  submissions?: SubmissionRow[]

  constructor() {
    const route = inject(ActivatedRoute)

    this.id = route.snapshot.params['id']
  }

  async ngOnInit() {
    this.benchmark = (
      await this.apiService.get('/definitions/benchmarks/:benchmark_ids', { params: { benchmark_ids: this.id } })
    ).body?.at(0)
    this.submissions = (
      await this.apiService.get('/submissions', { query: { benchmark_id: this.benchmark?.id as string } })
    ).body
  }
}
