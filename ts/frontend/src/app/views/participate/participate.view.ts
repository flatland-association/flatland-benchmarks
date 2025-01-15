import { Component } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-participate',
  imports: [FormsModule, ContentComponent],
  templateUrl: './participate.view.html',
  styleUrl: './participate.view.scss',
})
export class ParticipateView {
  submissionImageUrl = ''
  submissionResult?: string

  constructor(public apiService: ApiService) {}

  async submit() {
    const idRow = await this.apiService.post('submissions', {
      submission_image: this.submissionImageUrl,
    })
    if (idRow instanceof Array) {
      const id = idRow.at(0)?.id
      console.log(id)
      const interval = window.setInterval(() => {
        this.apiService.get(`submissions/${id}`).then((res) => {
          if (res) {
            this.submissionResult = JSON.stringify(res)
            window.clearInterval(interval)
          }
          console.log(res)
        })
      }, 1000)
    }
  }
}
