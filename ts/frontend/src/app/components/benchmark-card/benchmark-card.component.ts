import { Component, inject, Input, OnChanges, SimpleChanges } from '@angular/core'
import { RouterModule } from '@angular/router'
import { Benchmark, BenchmarkPreview } from '@common/interfaces'
import { CustomizationService } from '../../features/customization/customization.service'

@Component({
  selector: 'app-benchmark-card',
  imports: [RouterModule],
  templateUrl: './benchmark-card.component.html',
  styleUrl: './benchmark-card.component.scss',
})
export class BenchmarkCardComponent implements OnChanges {
  customizationService = inject(CustomizationService)

  @Input()
  benchmark?: Benchmark | BenchmarkPreview

  routerLink: string[] | null = null

  async ngOnChanges(changes: SimpleChanges) {
    if (changes['benchmark']) {
      if (this.benchmark) {
        const customization = await this.customizationService.getCustomization()
        if (customization.setup === 'campaign') {
          this.routerLink = ['/', 'vc-evaluation-objective', this.benchmark.id as string]
        } else {
          this.routerLink = ['/', 'benchmarks', this.benchmark.id as string]
        }
      } else {
        this.routerLink = null
      }
    }
  }
}
