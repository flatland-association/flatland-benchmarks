import { Component, OnInit } from '@angular/core'
import { BenchmarkPreview } from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { BenchmarkCardComponent } from '../../components/benchmark-card/benchmark-card.component'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-home',
  imports: [ContentComponent, SectionComponent, BenchmarkCardComponent],
  templateUrl: './home.view.html',
  styleUrl: './home.view.scss',
})
export class HomeView implements OnInit {
  benchmarks?: BenchmarkPreview[]

  constructor(public apiService: ApiService) {}

  async ngOnInit() {
    this.benchmarks = (await this.apiService.get('/benchmarks')).body
    this.benchmarks?.push({
      dir: '/benchmarks/',
      id: 'neurips_competition_2025',
      name: 'NeurIPS Competition 2025',
      description:
        'Towards Real-Time Train Rescheduling: Multi-Agent Reinforcement Learning and Operations Research for Dynamic Train Rescheduling under Stochastic Perturbations',
    })
  }
}
