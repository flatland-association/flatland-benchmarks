import { Component, Input, OnChanges, SimpleChanges } from '@angular/core'
import { RouterModule } from '@angular/router'
import { SuiteDefinitionRow } from '@common/interfaces'

@Component({
  selector: 'app-benchmark-group-card',
  imports: [RouterModule],
  templateUrl: './benchmark-group-card.component.html',
  styleUrl: './benchmark-group-card.component.scss',
})
export class BenchmarkGroupCardComponent implements OnChanges {
  @Input() suite?: SuiteDefinitionRow

  routerLink: string[] | null = null

  async ngOnChanges(changes: SimpleChanges) {
    if (changes['suite']) {
      if (this.suite) {
        this.routerLink = ['/', 'benchmarks', this.suite.id]
      } else {
        this.routerLink = null
      }
    }
  }
}
