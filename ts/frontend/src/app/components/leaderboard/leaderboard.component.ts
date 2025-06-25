import { CommonModule, DecimalPipe } from '@angular/common'
import { Component, Input, inject } from '@angular/core'
import { ActivatedRoute, Router } from '@angular/router'
import { SubmissionRow } from '@common/interfaces'

@Component({
  selector: 'app-leaderboard',
  imports: [CommonModule, DecimalPipe],
  templateUrl: './leaderboard.component.html',
  styleUrl: './leaderboard.component.scss',
})
export class LeaderboardComponent {
  private router = inject(Router)
  private route = inject(ActivatedRoute)

  @Input() submissions: SubmissionRow[] = []
  @Input() navigates = false

  click(submission: SubmissionRow) {
    if (this.navigates) {
      this.router.navigate(['submissions', submission.id], { relativeTo: this.route })
    }
  }
}
