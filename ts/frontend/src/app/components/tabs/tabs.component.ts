import { CommonModule } from '@angular/common'
import { Component, Input, OnChanges, SimpleChanges } from '@angular/core'

export interface Tab {
  title: string
  text: string
}

@Component({
  selector: 'app-tabs',
  imports: [CommonModule],
  templateUrl: './tabs.component.html',
  styleUrl: './tabs.component.scss',
})
export class TabsComponent implements OnChanges {
  @Input() tabs: Tab[] = []
  currentTab: Tab = { title: '', text: '' }

  ngOnChanges(_changes: SimpleChanges): void {
    this.currentTab = this.tabs[0]
  }
}
