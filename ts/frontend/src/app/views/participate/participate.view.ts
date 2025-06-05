import { Component, OnInit } from '@angular/core'
import { ActivatedRoute, RouterModule } from '@angular/router'
import { BenchmarkDefinitionRow, SubmissionPreview } from '@common/interfaces'
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
  id: string
  benchmark?: BenchmarkDefinitionRow
  submissions?: SubmissionPreview[]
  mySubmissions?: SubmissionPreview[]

  constructor(
    route: ActivatedRoute,
    public apiService: ApiService,
    private authService: AuthService,
  ) {
    this.id = route.snapshot.params['id']
  }

  async ngOnInit() {
    const myUuid = this.authService.userUuid
    this.benchmark = (await this.apiService.get('/benchmarks/:id', { params: { id: this.id } })).body?.at(0)
    this.submissions = (await this.apiService.get('/submissions', { query: { benchmark: this.benchmark?.id } })).body
    this.mySubmissions = (
      await this.apiService.get('/submissions', { query: { benchmark: this.benchmark?.id, submitted_by: myUuid } })
    ).body
  }
}
