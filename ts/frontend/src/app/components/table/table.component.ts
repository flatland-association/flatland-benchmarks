import { CommonModule } from '@angular/common'
import { Component, Input } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { RouterModule } from '@angular/router'
import { Scorings } from '@common/interfaces'

/**
 * Input in a cell.
 */
export interface TableInput {
  /** (Initial) value to display. */
  value: number | null
  /** Callback invoked when the input field changes. */
  onChange: (value: number) => void
}

/**
 * One column in a {@link TableComponent}.
 * Used to define the table heading and horizontal alignment.
 */
export interface TableColumn {
  /** Column title displayed in table heading. */
  title: string
  /** Horizontal alignment in column. Optional, default is left. */
  align?: 'left' | 'right' | 'center'
}

/**
 * One cell in a {@link TableRow}.
 * Each cell can hold exactly one property of the defined types:
 */
export type TableCell =
  | {
      /** Text to display in the cell. */
      text: string | number | null
      scorings?: undefined
      input?: undefined
    }
  | {
      text?: undefined
      /** Scorings to display in the cell. */
      scorings: Scorings | null
      input?: undefined
    }
  | {
      text?: undefined
      scorings?: undefined
      /** Input field to display in the cell. */
      input: TableInput
    }

/**
 * One row in a {@link TableComponent}.
 * Used to define the displayed table data.
 */
export interface TableRow {
  /** If set, clicking the row will route to this link. */
  routerLink?: string | string[]
  /** Cells in this row. */
  cells: TableCell[]
}

@Component({
  selector: 'app-table',
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './table.component.html',
  styleUrl: './table.component.scss',
})
export class TableComponent {
  @Input()
  columns: TableColumn[] = []

  @Input()
  rows: TableRow[] = []
}
