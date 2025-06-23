import { Component, OnInit, inject } from '@angular/core'
import { BenchmarkDefinitionRow } from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { BenchmarkCardComponent } from '../../components/benchmark-card/benchmark-card.component'
import { ApiService } from '../../features/api/api.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'

@Component({
  selector: 'view-home',
  imports: [ContentComponent, SectionComponent, BenchmarkCardComponent],
  templateUrl: './home.view.html',
  styleUrl: './home.view.scss',
})
export class HomeView implements OnInit {
  apiService = inject(ApiService)
  customizationService = inject(CustomizationService)

  benchmarks?: BenchmarkDefinitionRow[]
  customization?: Customization

  async ngOnInit() {
    this.benchmarks = (await this.apiService.get('/benchmarks')).body
    this.customization = await this.customizationService.getCustomization()
  }
}
