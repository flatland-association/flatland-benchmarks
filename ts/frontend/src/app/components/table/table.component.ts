import { CommonModule } from '@angular/common'
import { Component, effect, ElementRef, input, viewChild } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { RouterModule } from '@angular/router'
import { FieldDefinitionRow, Scoring } from '@common/interfaces'
import { ModalComponent } from '@flatland-association/flatland-ui'
import { FaIconComponent } from '@fortawesome/angular-fontawesome'
import {
  faArrowTurnDown,
  faCheck,
  faEllipsis,
  faFilter,
  faSort,
  faSortDown,
  faSortUp,
  faTrash,
} from '@fortawesome/free-solid-svg-icons'

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
  /** Sorting capabilities of column (defines default order). */
  sortable?: 'text' | 'number' | 'score' | 'date'
  /** Whether the column offers a filter. */
  filterable?: boolean
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
      fieldDefinitions?: undefined
      input?: undefined
    }
  | {
      text?: undefined
      /** Scorings to display in the cell. */
      scorings: Scoring[] | null
      /**
       * Meta data (field definitions) of Scorings to display. Optional, default
       * is to display `primary`.
       */
      fieldDefinitions?: (FieldDefinitionRow | undefined)[]
      input?: undefined
    }
  | {
      text?: undefined
      scorings?: undefined
      fieldDefinitions?: undefined
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
  imports: [CommonModule, FormsModule, RouterModule, FaIconComponent, ModalComponent],
  templateUrl: './table.component.html',
  styleUrl: './table.component.scss',
})
export class TableComponent {
  columns = input<TableColumn[]>([])
  rows = input<TableRow[]>([])

  filterFreeTextElem = viewChild<ElementRef<HTMLInputElement>>('filterFreeTextRef')

  displayRows: TableRow[] = []
  sorting: { column?: number; order?: 'asc' | 'desc' } = {}
  showFilterModal = false
  filterFreeText = ''
  filterOptions: string[] = []
  displayFilterOptions: string[] = []
  filterOptionSelected = -1
  filterColumn = -1
  filtering: Record<number, string> = {}
  NUM_FILTER_OPTIONS = 5

  faSort = faSort
  faSortUp = faSortUp
  faSortDown = faSortDown
  faFilter = faFilter
  faEllipsis = faEllipsis
  faCheck = faCheck
  faArrowTurnDown = faArrowTurnDown
  faTrash = faTrash

  constructor() {
    effect(() => {
      this.sortAndFilterRows()
    })
  }

  sortByColumn(columnIndex: number) {
    if (this.columns()[columnIndex].sortable) {
      let naturalOrder: typeof this.sorting.order = 'asc'
      // for score, sorting descending first makes more sense
      if (this.columns()[columnIndex].sortable === 'score') {
        naturalOrder = 'desc'
      }
      // if previously no sorting was active or a different column was sorted,
      // start with natural sorting
      if (columnIndex !== this.sorting.column) {
        this.sorting.column = columnIndex
        this.sorting.order = naturalOrder
      }
      // otherwise rotate from natural sorting to reversed to unsorted
      else if (this.sorting.order === naturalOrder) {
        this.sorting.order = naturalOrder === 'asc' ? 'desc' : 'asc'
      } else {
        this.sorting.column = undefined
        this.sorting.order = undefined
      }
    }
    this.sortAndFilterRows()
  }

  getRowCellText(row: TableRow, cellIndex: number) {
    const cell = row.cells[cellIndex]
    return `${cell.text ?? cell.scorings?.at(0)?.score ?? ''}`
  }

  // return a normalized form of text for consistent compare results
  getComparableTerm(text: string) {
    return text.toLocaleLowerCase()
  }

  showFilterForColumn(columnIndex: number) {
    if (this.columns()[columnIndex].filterable) {
      // reset keyboard navigation if column changed
      if (columnIndex !== this.filterColumn) {
        this.filterOptionSelected = -1
      }
      this.filterFreeText = this.filtering[columnIndex] ?? ''
      this.showFilterModal = true
      this.filterColumn = columnIndex
      setTimeout(() => {
        this.filterFreeTextElem()?.nativeElement.focus()
      }, 0)
      // only append options that compare-differ from already existing options
      this.filterOptions = []
      this.rows().forEach((row) => {
        const value = this.getRowCellText(row, columnIndex)
        const searchTerm = this.getComparableTerm(value)
        if (!this.filterOptions.includes(searchTerm)) {
          this.filterOptions.push(value)
        }
      })
      this.filterOptions.sort()
      this.updateDisplayFilterOptions(this.filterFreeText)
    }
  }

  // apply filter to filter options for sleek UI
  updateDisplayFilterOptions(text: string) {
    this.filterFreeText = text
    if (this.filterFreeText) {
      const searchTerm = this.getComparableTerm(this.filterFreeText)
      this.displayFilterOptions = this.filterOptions.filter((option) =>
        this.getComparableTerm(option).includes(searchTerm),
      )
    } else {
      this.displayFilterOptions = this.filterOptions
    }
  }

  onFilterDelete() {
    this.updateDisplayFilterOptions('')
    this.filterOptionSelected = -1
    setTimeout(() => {
      this.filterFreeTextElem()?.nativeElement.focus()
    }, 0)
  }

  onFilterApply() {
    this.applyFilter(this.filterFreeText)
  }

  onFilterKeyDown(event: KeyboardEvent) {
    switch (event.key) {
      case 'Enter':
        if (this.filterOptionSelected === -1) {
          this.applyFilter(this.filterFreeText)
        } else {
          this.applyFilter(this.displayFilterOptions[this.filterOptionSelected])
        }
        break
      case 'ArrowDown':
        this.filterOptionSelected += 1
        if (this.filterOptionSelected === this.NUM_FILTER_OPTIONS) this.filterOptionSelected = -1
        event.preventDefault()
        break
      case 'ArrowUp':
        this.filterOptionSelected -= 1
        if (this.filterOptionSelected < -1) this.filterOptionSelected = this.NUM_FILTER_OPTIONS - 1
        event.preventDefault()
        break
      default:
        break
    }
  }

  applyFilter(filter: string) {
    if (filter) {
      this.filtering[this.filterColumn] = filter
    } else {
      delete this.filtering[this.filterColumn]
    }
    this.sortAndFilterRows()
    this.showFilterModal = false
  }

  sortAndFilterRows() {
    // start by copying all rows
    this.displayRows = [...this.rows()]
    // filter
    for (const cidx in this.filtering) {
      const searchTerm = this.getComparableTerm(this.filtering[cidx])
      this.displayRows = this.displayRows.filter((row) => {
        return this.getComparableTerm(this.getRowCellText(row, +cidx)).includes(searchTerm)
      })
    }
    // sort
    const cidx = this.sorting.column
    const order = this.sorting.order === 'asc' ? +1 : -1
    if (typeof cidx === 'number') {
      const sorting = this.columns()[cidx].sortable
      const getComparableValue = (cell: TableCell) => {
        switch (sorting) {
          case 'score':
            return cell.scorings?.at(0)?.score ?? 0
          case 'number':
            return +(cell.text ?? '0')
          case 'date':
            return new Date(`${cell.text}`)
          default:
            return cell.text ?? ''
        }
      }
      this.displayRows.sort((a, b) => {
        const valA = getComparableValue(a.cells[cidx])
        const valB = getComparableValue(b.cells[cidx])
        return valA > valB ? order : -order
      })
    }
  }

  getPrimaryScoring(cell: TableCell) {
    return cell.scorings?.[0]
  }
}
