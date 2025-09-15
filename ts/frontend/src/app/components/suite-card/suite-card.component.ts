import { Component, Input, OnChanges, SimpleChanges } from '@angular/core'
import { RouterModule } from '@angular/router'
import { SuiteDefinitionRow } from '@common/interfaces'

@Component({
  selector: 'app-suite-card',
  imports: [RouterModule],
  templateUrl: './suite-card.component.html',
  styleUrl: './suite-card.component.scss',
})
export class SuiteCardComponent implements OnChanges {
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
