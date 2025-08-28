import { Component, Input, OnChanges, SimpleChanges } from '@angular/core'
import { RouterModule } from '@angular/router'
import { BenchmarkGroupDefinitionRow } from '@common/interfaces'

@Component({
  selector: 'app-benchmark-group-card',
  imports: [RouterModule],
  templateUrl: './benchmark-group-card.component.html',
  styleUrl: './benchmark-group-card.component.scss',
})
export class BenchmarkGroupCardComponent implements OnChanges {
  @Input() group?: BenchmarkGroupDefinitionRow

  routerLink: string[] | null = null

  async ngOnChanges(changes: SimpleChanges) {
    if (changes['group']) {
      if (this.group) {
        this.routerLink = ['/', 'benchmarks', this.group.id]
      } else {
        this.routerLink = null
      }
    }
  }
}
