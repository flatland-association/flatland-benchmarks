import { Component, OnInit, inject } from '@angular/core'
import { RouterModule } from '@angular/router'
import { BenchmarkDefinitionRow } from '@common/interfaces'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { BenchmarkGroupCardComponent } from '../../components/benchmark-group-card/benchmark-group-card.component'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-benchmarks',
  imports: [ContentComponent, RouterModule, BenchmarkGroupCardComponent],
  templateUrl: './benchmarks.view.html',
  styleUrl: './benchmarks.view.scss',
})
export class BenchmarkView implements OnInit {
  apiService = inject(ApiService)

  benchmarks?: BenchmarkDefinitionRow[]

  async ngOnInit() {
    this.benchmarks = (await this.apiService.get('/definitions/benchmarks')).body
  }
}
