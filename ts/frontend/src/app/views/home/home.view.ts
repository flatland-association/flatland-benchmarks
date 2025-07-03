import { Component, OnInit, inject } from '@angular/core'
import { BenchmarkGroupDefinitionRow } from '@common/interfaces'
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

  groups?: BenchmarkGroupDefinitionRow[]
  customization?: Customization
  leadHtml?: string

  async ngOnInit() {
    this.customization = await this.customizationService.getCustomization()
    this.groups = (await this.apiService.get('/definitions/benchmark-groups')).body
    this.leadHtml = this.customization.content.home.lead
  }
}
