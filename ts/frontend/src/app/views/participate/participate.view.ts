import { Component, OnInit } from '@angular/core'
import { RouterModule } from '@angular/router'
import { Benchmark } from '@common/interfaces.mjs'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { BenchmarkCardComponent } from '../../components/benchmark-card/benchmark-card.component'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-participate',
  imports: [ContentComponent, RouterModule, BenchmarkCardComponent],
  templateUrl: './participate.view.html',
  styleUrl: './participate.view.scss',
})
export class ParticipateView implements OnInit {
  benchmarks?: Benchmark[]

  constructor(public apiService: ApiService) {}

  async ngOnInit() {
    const URIs = (await this.apiService.get('/benchmarks')).body
    // TODO: concentrate requests
    this.benchmarks = URIs
      ? (
          await Promise.all(
            URIs?.map(async (uri) => {
              return (await this.apiService.get<Benchmark[]>(uri)).body?.at(0)
            }),
          )
        ).filter((b) => !!b)
      : []
  }
}
