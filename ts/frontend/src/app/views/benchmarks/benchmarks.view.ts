import { Component, OnInit } from '@angular/core'
import { RouterModule } from '@angular/router'
import { BenchmarkDefinitionRow } from '@common/interfaces'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { BenchmarkCardComponent } from '../../components/benchmark-card/benchmark-card.component'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-benchmarks',
  imports: [ContentComponent, RouterModule, BenchmarkCardComponent],
  templateUrl: './benchmarks.view.html',
  styleUrl: './benchmarks.view.scss',
})
export class BenchmarkView implements OnInit {
  benchmarks?: BenchmarkDefinitionRow[]

  constructor(public apiService: ApiService) {}

  async ngOnInit() {
    this.benchmarks = (await this.apiService.get('/benchmarks')).body
  }
}
