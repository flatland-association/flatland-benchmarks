import { Component, OnInit } from '@angular/core'
import { RouterModule } from '@angular/router'
import { consolidateResourceLocator, endpointFromResourceLocator } from '@common/endpoint-utils.mjs'
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
    const locators = (await this.apiService.get('/benchmarks')).body
    if (locators) {
      const combined = consolidateResourceLocator(locators)
      this.benchmarks = (await this.apiService.get<Benchmark[]>(...endpointFromResourceLocator(combined))).body
    }
  }
}
