import { CommonModule } from '@angular/common'
import { Component, OnInit } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute, RouterModule } from '@angular/router'
import { BenchmarkDefinitionRow, SubmissionPreview } from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { LeaderboardComponent } from '../../components/leaderboard/leaderboard.component'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-benchmarks-detail',
  imports: [
    CommonModule,
    FormsModule,
    RouterModule,
    ContentComponent,
    SectionComponent,
    BreadcrumbsComponent,
    LeaderboardComponent,
  ],
  templateUrl: './benchmarks-detail.view.html',
  styleUrl: './benchmarks-detail.view.scss',
})
export class BenchmarksDetailView implements OnInit {
  id: string
  benchmark?: BenchmarkDefinitionRow
  submissions?: SubmissionPreview[]

  constructor(
    route: ActivatedRoute,
    public apiService: ApiService,
  ) {
    this.id = route.snapshot.params['id']
  }

  async ngOnInit() {
    this.benchmark = (await this.apiService.get('/benchmarks/:id', { params: { id: this.id } })).body?.at(0)
    this.submissions = (await this.apiService.get('/submissions', { query: { benchmark: this.benchmark?.id } })).body
  }
}
