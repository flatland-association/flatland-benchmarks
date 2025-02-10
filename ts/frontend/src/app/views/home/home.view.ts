import { Component, OnInit } from '@angular/core'
import { BenchmarkPreview } from '@common/interfaces.mjs'
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
  }
}
