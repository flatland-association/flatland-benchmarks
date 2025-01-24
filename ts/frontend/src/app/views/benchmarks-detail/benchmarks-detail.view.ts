import { Component, OnInit } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute } from '@angular/router'
import { Benchmark } from '@common/interfaces.mjs'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-benchmarks-detail',
  imports: [FormsModule, ContentComponent],
  templateUrl: './benchmarks-detail.view.html',
  styleUrl: './benchmarks-detail.view.scss',
})
export class BenchmarksDetailView implements OnInit {
  id: string
  benchmark?: Benchmark

  submissionImageUrl = ''
  submissionResult?: string

  constructor(
    route: ActivatedRoute,
    public apiService: ApiService,
  ) {
    this.id = route.snapshot.params['id']
  }

  async ngOnInit() {
    this.benchmark = (await this.apiService.get('/benchmarks/:id', { params: { id: this.id } })).body?.at(0)
  }

  async submit() {
    const response = await this.apiService.post('/submissions', {
      body: { submission_image: this.submissionImageUrl },
    })
    if (response.body?.id) {
      const id = response.body.id
      console.log(id)
      const interval = window.setInterval(() => {
        this.apiService.get('/submissions/:id', { params: { id: `${id}` } }).then((res) => {
          if (res.body) {
            this.submissionResult = JSON.stringify(res.body)
            window.clearInterval(interval)
          }
          console.log(res)
        })
      }, 1000)
    }
  }
}
