import { Component, Input } from '@angular/core'
import { RouterModule } from '@angular/router'
import { Benchmark, BenchmarkPreview } from '@common/interfaces'

@Component({
  selector: 'app-benchmark-card',
  imports: [RouterModule],
  templateUrl: './benchmark-card.component.html',
  styleUrl: './benchmark-card.component.scss',
})
export class BenchmarkCardComponent {
  @Input()
  benchmark?: Benchmark | BenchmarkPreview
}
