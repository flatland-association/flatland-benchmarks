import { Component, OnInit, inject } from '@angular/core'
import { ActivatedRoute, RouterModule } from '@angular/router'
import { BenchmarkDefinitionRow, SubmissionRow } from '@common/interfaces'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { LeaderboardComponent } from '../../components/leaderboard/leaderboard.component'
import { ApiService } from '../../features/api/api.service'
import { AuthService } from '../../features/auth/auth.service'

@Component({
  selector: 'view-participate',
  imports: [RouterModule, ContentComponent, BreadcrumbsComponent, LeaderboardComponent],
  templateUrl: './participate.view.html',
  styleUrl: './participate.view.scss',
})
export class ParticipateView implements OnInit {
  apiService = inject(ApiService)
  private authService = inject(AuthService)

  id: string
  benchmark?: BenchmarkDefinitionRow
  submissions?: SubmissionRow[]
  mySubmissions?: SubmissionRow[]

  constructor() {
    const route = inject(ActivatedRoute)

    this.id = route.snapshot.params['id']
  }

  async ngOnInit() {
    const myUuid = this.authService.userUuid
    this.benchmark = (
      await this.apiService.get('/definitions/benchmarks/:benchmark_ids', { params: { benchmark_ids: this.id } })
    ).body?.at(0)
    this.submissions = (
      await this.apiService.get('/submissions', { query: { benchmark_ids: this.benchmark?.id as string } })
    ).body
    this.mySubmissions = (
      await this.apiService.get('/submissions', {
        query: { benchmark_ids: this.benchmark?.id as string, submitted_by: myUuid },
      })
    ).body
  }
}
