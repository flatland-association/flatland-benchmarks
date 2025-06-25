import { Component, inject, OnInit } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute, Router } from '@angular/router'
import { BenchmarkDefinitionRow, TestDefinitionRow } from '@common/interfaces'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-vc-new-submission',
  imports: [FormsModule, ContentComponent, BreadcrumbsComponent],
  templateUrl: './vc-new-submission.view.html',
  styleUrl: './vc-new-submission.view.scss',
})
export class VcNewSubmissionView implements OnInit {
  apiService = inject(ApiService)
  private router = inject(Router)

  benchmarkId: string
  testId: string

  benchmark?: BenchmarkDefinitionRow
  test?: TestDefinitionRow

  submissionUrl = ''
  submissionName = ''

  constructor() {
    const route = inject(ActivatedRoute)

    this.benchmarkId = route.snapshot.params['benchmark_id']
    this.testId = route.snapshot.params['test_id']
  }

  async ngOnInit() {
    // TODO: offload this to service with caching
    this.benchmark = (await this.apiService.get('/benchmarks/:id', { params: { id: this.benchmarkId } })).body?.at(0)
    this.test = (await this.apiService.get('/tests/:id', { params: { id: this.testId } })).body?.at(0)
  }

  canSubmit() {
    return this.submissionName != '' && this.submissionUrl != '' && !this.submissionUrl.includes(' ')
  }

  async submit() {
    const response = await this.apiService.post('/submissions', {
      body: {
        name: this.submissionName,
        benchmark_definition_id: this.benchmark?.id ?? '',
        submission_data_url: this.submissionUrl,
        test_definition_ids: [this.testId],
      },
    })
    if (response.body?.id) {
      // navigate to my submissions
      this.router.navigateByUrl(`vc-evaluation-objective/${this.benchmarkId}/my-submissions`)
    }
  }
}
