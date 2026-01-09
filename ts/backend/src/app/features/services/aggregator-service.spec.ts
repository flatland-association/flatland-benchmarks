import { FieldDefinitionRow, SubmissionScore } from '@common/interfaces'
import { afterEach, beforeAll, beforeEach, describe, expect, MockInstance, test, vi } from 'vitest'
import { loadConfig } from '../config/config.mjs'
import { Logger } from '../logger/logger.mjs'
import { AggregatorService, SubmissionScoreSources } from './aggregator-service.mjs'

Logger.setOptions({ '--log-level': 'OFF' })

type AggFunc = keyof Pick<
  AggregatorService,
  'aggSum' | 'aggNaNSum' | 'aggMean' | 'aggNaNMean' | 'aggMedian' | 'aggNaNMedian'
>

interface AggFuncTestCase {
  func: AggFunc
  values: (number | null)[]
  result: number | null
}

const aggFuncs: AggFunc[] = ['aggSum', 'aggNaNSum', 'aggMean', 'aggNaNMean', 'aggMedian', 'aggNaNMedian']

const dummyBoard: { items: SubmissionScore[] } = {
  items: [
    {
      submission_id: 'fcf1dcd0-eddb-4485-a415-66b680b136be',
      test_scorings: [],
      scorings: [
        // field_ids are not relevant for testing, but required in type
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'all_asc', score: 0.8 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'some_asc', score: 0.8 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'some_null', score: 0.8 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'negative', score: -800 },
      ],
    },
    {
      submission_id: '5b711a38-1e16-4883-be2d-cd5902b9c8ee',
      test_scorings: [],
      scorings: [
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'all_asc', score: 0.9 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'some_asc', score: 0.8 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'negative', score: -900 },
      ],
    },
    {
      submission_id: 'fce5162c-8288-40c5-b72b-cc7252afb28c',
      test_scorings: [],
      scorings: [
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'all_asc', score: 0.7 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'some_asc', score: 0.7 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'some_null', score: 0.7 },
        { field_id: '077e3d77-5609-427c-9ae0-d0099cae6259', field_key: 'negative', score: -700 },
      ],
    },
  ],
}

describe('Aggregator Service', () => {
  beforeAll(() => {
    const config = loadConfig()

    // Database connectivity not required in unit tests - set to unreachable
    // target to prevent accidental access and to test error behavior.
    config.postgres.host = 'nix.com'
    config.postgres.port = 1 // do not use 0 - would fall back to default

    AggregatorService.create(config)
  })

  test('is instantiated despite faulty config', () => {
    const aggregator = AggregatorService.getInstance()
    expect(aggregator).toBeTruthy()
  })

  describe('yields correct aggregation results', () => {
    test.each([
      // not putting numbers in order, to show that median actually does a thing
      { func: 'aggSum', values: [], result: null },
      { func: 'aggSum', values: [2, 1, null], result: null },
      { func: 'aggSum', values: [2, 1, 3], result: 6 },
      { func: 'aggNaNSum', values: [], result: null },
      { func: 'aggNaNSum', values: [2, 1, null], result: 3 },
      { func: 'aggNaNSum', values: [2, 1, 3], result: 6 },
      { func: 'aggMean', values: [], result: null },
      { func: 'aggMean', values: [2, 1, null], result: null },
      { func: 'aggMean', values: [2, 1, 3], result: 2 },
      { func: 'aggNaNMean', values: [], result: null },
      { func: 'aggNaNMean', values: [2, 1, null], result: 1.5 },
      { func: 'aggNaNMean', values: [2, 1, 3], result: 2 },
      { func: 'aggMedian', values: [], result: null },
      { func: 'aggMedian', values: [2, 1, null], result: null },
      { func: 'aggMedian', values: [2, 1, 3], result: 2 },
      { func: 'aggNaNMedian', values: [], result: null },
      { func: 'aggNaNMedian', values: [2, 1, null], result: 1.5 },
      { func: 'aggNaNMedian', values: [2, 1, 3], result: 2 },
    ] satisfies AggFuncTestCase[])('returns $result from $values with $func', (testCase) => {
      const aggregator = AggregatorService.getInstance()
      const result = aggregator[testCase.func](testCase.values)
      expect(result).toBe(testCase.result)
    })
  })

  describe('calls defined aggregator function or null', async () => {
    const mocks: Record<string, MockInstance> = {}

    beforeEach(() => {
      for (const aggFunc of aggFuncs) {
        mocks[aggFunc] = vi.spyOn(AggregatorService.prototype, aggFunc)
      }
    })

    afterEach(() => {
      for (const aggFunc of aggFuncs) {
        mocks[aggFunc].mockReset()
      }
    })

    test.each([
      { agg_func: 'SUM', func: 'aggSum' },
      { agg_func: 'NANSUM', func: 'aggNaNSum' },
      { agg_func: 'MEAN', func: 'aggMean' },
      { agg_func: 'NANMEAN', func: 'aggNaNMean' },
      { agg_func: 'MEDIAN', func: 'aggMedian' },
      { agg_func: 'NANMEDIAN', func: 'aggNaNMedian' },
      { agg_func: 'TYPO', func: null },
    ] satisfies { agg_func: string; func: AggFunc | null }[])('calls $func for $agg_func', (testCase) => {
      const aggregator = AggregatorService.getInstance()
      aggregator.runAggregationFunction([], testCase.agg_func)
      if (testCase.func) {
        expect(mocks[testCase.func]).toBeCalledTimes(1)
      }
    })
  })

  describe('looks up defined in field', () => {
    test.each([
      {
        agg_fields: null,
        index: undefined,
        returns: 'primary',
      },
      {
        agg_fields: 'primary_from_test',
        index: undefined,
        returns: 'primary_from_test',
      },
      {
        agg_fields: ['primary', 'secondary'],
        index: 0,
        returns: 'primary',
      },
      {
        agg_fields: ['primary', 'secondary'],
        index: 1,
        returns: 'secondary',
      },
      {
        agg_fields: ['primary', 'secondary'],
        index: 2,
        returns: undefined,
      },
    ] satisfies (Pick<FieldDefinitionRow, 'agg_fields'> | { index: number | undefined; returns: string })[])(
      'returns $returns for agg_fields = $agg_fields with index = $index',
      (testCase) => {
        const dummyFieldDefinition: FieldDefinitionRow = {
          id: '41f16002-d807-4722-90a6-d191e6e54adf',
          key: 'primary',
          description: '',
        }
        dummyFieldDefinition.agg_fields = testCase.agg_fields
        const aggregator = AggregatorService.getInstance()
        const fieldName = aggregator.getInFieldName(dummyFieldDefinition, testCase.index ?? 0)
        expect(fieldName).toBe(testCase.returns)
      },
    )
  })

  describe('correctly tracks rank and highest/lowest score for all items', () => {
    let board: typeof dummyBoard

    beforeEach(() => {
      board = structuredClone(dummyBoard)
      const aggregator = AggregatorService.getInstance()
      aggregator.rankBoard(board)
    })

    test.each([
      // in positive scoring cases, lowest score is bound to 0
      { case: 'all ascending', field: 'all_asc', ranks: [2, 1, 3], highest: 0.9, lowest: 0 },
      { case: 'some ascending', field: 'some_asc', ranks: [1, 1, 3], highest: 0.8, lowest: 0 },
      { case: 'some missing', field: 'some_null', ranks: [1, 3, 2], highest: 0.8, lowest: 0 },
      // in highest scoring cases, highest score is bound to 0
      { case: 'negative scores', field: 'negative', ranks: [2, 3, 1], highest: 0, lowest: -900 },
    ])('in case $case', (testCase) => {
      board.items.forEach((submissionScore, index) => {
        const scoring = submissionScore.scorings.find((s) => s.field_key === testCase.field)
        if (scoring) {
          expect(scoring.rank).toBe(testCase.ranks[index])
          expect(scoring.highest).toBe(testCase.highest)
          expect(scoring.lowest).toBe(testCase.lowest)
        }
      })
    })
  })

  test('calculate submission score correctly with only selected tests and agg_fields present in the benchmark definition', () => {
    const sources = {
      submissions: [
        {
          id: 'c3ce1c1c-f1ca-4ab4-8da9-b6dc43c588d0',
          name: 'blup22',
          status: 'SUBMITTED',
          test_ids: ['98ceb866-5479-47e6-a735-81292de8ca65'],
          published: true,
          description: null,
          benchmark_id: '3b1bdca6-ed90-4938-bd63-fd657aa7dcd7',
          submitted_at: '2026-01-09T10:22:01.784008',
          submitted_by: '53e2038c-0c5f-4536-9a3c-71c82f49119a',
          code_repository: '',
          submission_data_url: 'ghcr.io/flatland-association/flatland-baselines-deadlock-avoidance-heuristic:latest',
          submitted_by_username: 'user',
        },
      ],
      benchmarks: [
        {
          id: '3b1bdca6-ed90-4938-bd63-fd657aa7dcd7',
          name: 'Effectiveness',
          contents: null,
          test_ids: [
            'aba10b3f-0d5c-4f90-aec4-69460bbb098b',
            '6ff3c588-357c-41a6-a45a-2bd946b158c8',
            '5d1db79c-a7a4-4060-bb03-4629d64b1a43',
            '98ceb866-5479-47e6-a735-81292de8ca65',
            '9b6bc151-9f25-4d85-bee1-919753934521',
            '1e226684-a836-468d-9929-b95bbf2f88dc',
            'a6cb2703-be7f-44da-a3d8-652fa8797627',
            '58ce79e0-5c14-4c51-8d09-89f856361259',
          ],
          field_ids: ['33c1f8a3-5764-44cc-988b-0f9a53b7f4a1'],
          description: 'Effectiveness',
          campaign_field_ids: [],
          suite_id: null,
        },
      ],
      tests: [
        {
          id: '1e226684-a836-468d-9929-b95bbf2f88dc',
          loop: 'CLOSED',
          name: 'KPI-AF-029: AI Response time (Railway)',
          queue: 'Railway',
          field_ids: ['e00859c3-d3e5-4bdf-9025-2030e22df317'],
          description:
            'The Response Time KPI measures the time taken by the AI-assisted railway re-scheduling system to generate a new operational schedule in response to a disruption. This metric evaluates how quickly the system reacts to unexpected events, ensuring minimal delays and maintaining operational efficiency. ',
          scenario_ids: ['c5219c2e-c3b9-4e7a-aefc-b767a9b3005d'],
        },
        {
          id: '58ce79e0-5c14-4c51-8d09-89f856361259',
          loop: 'INTERACTIVE',
          name: 'KPI-TS-035: Total decision time (Power Grid)',
          queue: 'PowerGrid',
          field_ids: ['10aadaaf-daa4-4098-bd9d-2042ecb488e9'],
          description:
            'It is based on the overall time needed to decide, thus including the respective time taken by the AI assistant and human operator. This KPI can be detailed to specifically distinguish the time needed by the AI assistant to provide a recommendation.<br/>An assumption is that a Human Machine Interaction (HMI) module is available.  ',
          scenario_ids: ['1294d425-66bd-4510-b4b3-d9f64ca0e4f9'],
        },
        {
          id: '5d1db79c-a7a4-4060-bb03-4629d64b1a43',
          loop: 'CLOSED',
          name: 'KPI-NF-024: Network utilization (Power Grid)',
          queue: 'PowerGrid',
          field_ids: ['63e93356-5033-451f-a3c2-cd607721661f'],
          description:
            'Network utilization KPI is based on the relative line loads of the network, indicating to what extent the network and its components are utilized.',
          scenario_ids: ['ed8ba2fc-853e-4e79-a984-b1986b9b6e97'],
        },
        {
          id: '6ff3c588-357c-41a6-a45a-2bd946b158c8',
          loop: 'CLOSED',
          name: 'KPI-DF-016: Delay reduction efficiency (Railway)',
          queue: 'Railway',
          field_ids: ['0c1be4b0-c30f-4e38-a698-3b141181ede6'],
          description:
            "The Delay Reduction Efficiency KPI quantifies the effectiveness of the AI-driven re-scheduling system in reducing overall train delays. By comparing delays before and after AI intervention, this metric provides insight into the system's capability to optimize train schedules and minimize disruptions. ",
          scenario_ids: ['ba7f9aac-5e96-4436-bae1-23629c4d153b'],
        },
        {
          id: '98ceb866-5479-47e6-a735-81292de8ca65',
          loop: 'CLOSED',
          name: 'KPI-PF-026: Punctuality (Railway)',
          queue: 'Railway',
          field_ids: ['1de0f52c-ae47-4847-9148-97b8568952d3'],
          description:
            'Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ',
          scenario_ids: ['5a60713d-01f2-4d32-9867-21904629e254', '0db72a40-43e8-477b-89b3-a7bd1224660a'],
        },
        {
          id: '9b6bc151-9f25-4d85-bee1-919753934521',
          loop: 'CLOSED',
          name: 'KPI-RF-027: Reduction in delay (ATM)',
          queue: 'ATM',
          field_ids: ['ca6afe0e-a91a-4683-b735-6069e6b0cd8a'],
          description:
            'The reduction in delay KPI aims to quantify the time gained overall and for each airplane, with the introduction of AI. ',
          scenario_ids: ['437971ac-6616-429b-ad27-f8796772c570'],
        },
        {
          id: 'a6cb2703-be7f-44da-a3d8-652fa8797627',
          loop: 'INTERACTIVE',
          name: 'KPI-SS-032: System efficiency (ATM)',
          queue: 'ATM',
          field_ids: ['67a19c4b-1873-4a44-8c07-e15d9ede1e78'],
          description:
            'System efficiency measures the efficiency of the system in delivering trustworthy solutions requiring less effort and time to deliver an appropriate response by the operator.  ',
          scenario_ids: ['22ef21e7-d00d-4c3b-8484-7110e024a4f5'],
        },
        {
          id: 'aba10b3f-0d5c-4f90-aec4-69460bbb098b',
          loop: 'CLOSED',
          name: 'KPI-AF-008: Assistant alert accuracy (Power Grid)',
          queue: 'PowerGrid',
          field_ids: ['fcabd61d-91bc-45dc-8bf8-7aeb9724cb67'],
          description:
            'Assistant alert accuracy is based on the number of times the AI assistant agent is right about forecasted issues ahead of time.<br/>Even if forecasted issues concern all events that lead to a grid state out of acceptable limits (set by operation policy), use cases of the project focus on managing overloads only: this KPI therefore only focuses on alerts related to line overloads.<br/>The calculation of KPI relies on simulation of 2 parallel paths (starting from the moment the alert is raised):<br/>- Simulation of the “do nothing” path, to assess the truth values<br/>- Application of remedial actions to the “do nothing” path, to assess solved cases<br/>To calculate the KPI, all interventions by an agent or operator are fixed to a specific plan since every alert is related to a specific plan (e.g. remedial actions).<br/>Note: line contingencies for which alerts can be raised are the lines that can be attacked in the environment (env.alertable_line_ids in grid2Op), so this should be properly configured beforehand. ',
          scenario_ids: ['729cc815-ac93-4209-9f62-b57b920c2d0a'],
        },
      ],
      scenarios: [
        {
          id: '0db72a40-43e8-477b-89b3-a7bd1224660a',
          name: 'Scenario 001 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ',
          field_ids: ['f0f478d6-436e-476f-be79-33d8c34f20c1', 'a5c6d789-0c00-413d-b689-862806dd9b56'],
          description:
            'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>',
        },
        {
          id: '1294d425-66bd-4510-b4b3-d9f64ca0e4f9',
          name: 'Scenario 1 - It is based on the overall time needed to decide, thus including the respective time taken by the AI assistant and human operator. This KPI can be detailed to specifically distinguish the time needed by the AI assistant to provide a recommendation.<br/>An assumption is that a Human Machine Interaction (HMI) module is available.  ',
          field_ids: ['fb1070a5-c929-4cd6-9723-1a5da97bfdf3'],
          description:
            'This KPI addresses the following objectives:<br/>1. Given an alert, how much time is left until the problem occurs?<br/>The longer the better since it gives more time to make a decision.<br/>2. Given an alert, how much time does the AI assistant take to come up with its recommendations to mitigate the issue?<br/>The shorter the better.<br/>3. Given the recommendations by the AI assistant, how much time does the human operator take to make a final decision?<br/>The shorter the better since it indicates that the recommendations are clear and convincing for the human operator.<br/>In case there is no interaction possible between the AI assistant and the human operator, this overall split is not possible. Then there is only one overall time needed to decide, starting from the alert and ending with the final decision by the human operator.<br/>This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ',
        },
        {
          id: '22ef21e7-d00d-4c3b-8484-7110e024a4f5',
          name: 'Scenario 1 - System efficiency measures the efficiency of the system in delivering trustworthy solutions requiring less effort and time to deliver an appropriate response by the operator.  ',
          field_ids: ['e11b124d-af80-42b7-86d1-355ce9ee83c9'],
          description:
            'The System efficiency KPI aims to evaluate the effectiveness of the AI solution in real operational conditions, considering not just its raw response time but also the quality and usability of its assistance. This includes how the AI presents its advice, its ease of use, the accuracy of its recommendations, and how well it integrates with existing data and workflows.<br/>The evaluation will measure the AI-human collaboration, focusing on:<br/>- Response efficiency: The time taken for the AI to generate advice and for the human operator to act on it.<br/>- Advice clarity & usability: How well structured, coherent, and understandable the AI’s suggestions are.<br/>- Data integration quality: How seamlessly the AI incorporates relevant information into its recommendations.<br/>- Human correction factor: Whether and how often the operator needs to correct or refine the AI’s output.<br/>- Decision-making speed: The overall reduction in response time achieved through AI-assisted operation.<br/>By considering these f',
        },
        {
          id: '437971ac-6616-429b-ad27-f8796772c570',
          name: 'Scenario 1 - The reduction in delay KPI aims to quantify the time gained overall and for each airplane, with the introduction of AI. ',
          field_ids: ['de36c069-a167-4c22-8b30-3f93e6588507'],
          description:
            'This KPI aims to quantify the efficiency gains of AI integration by measuring how AI impacts execution time and delays. Specifically, it helps determine whether AI:<br/>- Reduces execution time deviations<br/>- Minimizes delays<br/>- Enhances consistency and reliability in operations.<br/>By evaluating these metrics, we can assess the AI’s effectiveness in improving human decision-making, reducing intervention time, and optimizing operational workflows.<br/>This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective.<br/>This KPI is linked with project’s Long Term Expected Impact (LTEI) (LTEI1)KPIS-4, 3-6% improvement in flight capacity and mile extension. ',
        },
        {
          id: '5a60713d-01f2-4d32-9867-21904629e254',
          name: 'Scenario 000 - Punctuality measures the percentage of trains arriving at their destinations on time (the train doesn’t arrive after planned arrival) and the train didn’t depart before planned departure time. The goal is to maintain a high level of reliability and minimize delays for passengers and freight services. ',
          field_ids: ['c2a66425-186d-423b-b002-391c091b33c6', 'f56b119f-719d-4601-94ff-e511b2aaeeed'],
          description:
            'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- Improve customer satisfaction by ensuring timely arrivals<br/>- Guarantee maximal planned connection<br/>- Minimize operational disruptions caused by delays<br/>- Meet regulatory and stakeholder benchmarks for punctuality<br/>This KPI is linked with project’s Long Term Expected Impacts (LTEI) (LTEI1)KPIS-3:<br/>- 10% increase in punctuality in long-range traffic<br/>- 5% increase in punctuality in regional traffic (with realistic disturbances)<br/>',
        },
        {
          id: '729cc815-ac93-4209-9f62-b57b920c2d0a',
          name: 'Scenario 1 - Assistant alert accuracy is based on the number of times the AI assistant agent is right about forecasted issues ahead of time.<br/>Even if forecasted issues concern all events that lead to a grid state out of acceptable limits (set by operation policy), use cases of the project focus on managing overloads only: this KPI therefore only focuses on alerts related to line overloads.<br/>The calculation of KPI relies on simulation of 2 parallel paths (starting from the moment the alert is raised):<br/>- Simulation of the “do nothing” path, to assess the truth values<br/>- Application of remedial actions to the “do nothing” path, to assess solved cases<br/>To calculate the KPI, all interventions by an agent or operator are fixed to a specific plan since every alert is related to a specific plan (e.g. remedial actions).<br/>Note: line contingencies for which alerts can be raised are the lines that can be attacked in the environment (env.alertable_line_ids in grid2Op), so this should be properly configu',
          field_ids: ['7f5b985b-d3a9-4e96-bd01-53ca1b73b256'],
          description:
            'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ',
        },
        {
          id: 'ba7f9aac-5e96-4436-bae1-23629c4d153b',
          name: "Scenario 1 - The Delay Reduction Efficiency KPI quantifies the effectiveness of the AI-driven re-scheduling system in reducing overall train delays. By comparing delays before and after AI intervention, this metric provides insight into the system's capability to optimize train schedules and minimize disruptions. ",
          field_ids: ['18da02bc-6f0c-4cac-a080-ee03974d9a8d'],
          description:
            'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- To assess the impact of AI-based re-scheduling on reducing delays in railway operations.<br/>- To ensure that AI interventions lead to measurable improvements in punctuality.<br/>- To provide a performance benchmark for AI-driven traffic management solutions in railway networks. ',
        },
        {
          id: 'c5219c2e-c3b9-4e7a-aefc-b767a9b3005d',
          name: 'Scenario 1 - The Response Time KPI measures the time taken by the AI-assisted railway re-scheduling system to generate a new operational schedule in response to a disruption. This metric evaluates how quickly the system reacts to unexpected events, ensuring minimal delays and maintaining operational efficiency. ',
          field_ids: ['35d6834e-5f89-438b-adcc-326bbeda93e2'],
          description:
            'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective:<br/>- To assess the speed of AI-assisted decision-making in railway operations.<br/>- To ensure rapid re-scheduling of trains in response to disturbances, minimizing the impact on passengers and freight.<br/>- To compare AI-assisted response times with traditional manual re-scheduling approaches. ',
        },
        {
          id: 'ed8ba2fc-853e-4e79-a984-b1986b9b6e97',
          name: 'Scenario 1 - Network utilization KPI is based on the relative line loads of the network, indicating to what extent the network and its components are utilized.',
          field_ids: ['68a7aead-7408-4cfa-92ee-8c108e0bf5c7'],
          description:
            'This KPI contributes to evaluating Effectiveness of the AI-based assistant, as part of Task 4.1 evaluation objectives, and O2 main project objective. ',
        },
      ],
      fields: [
        {
          id: '0c1be4b0-c30f-4e38-a698-3b141181ede6',
          key: 'primary',
          agg_func: 'MEAN',
          agg_fields: ['primary'],
          agg_lateral: null,
          agg_weights: null,
          description: 'Test score (MEAN of scenario scores)',
        },
        {
          id: '10aadaaf-daa4-4098-bd9d-2042ecb488e9',
          key: 'primary',
          agg_func: 'MEAN',
          agg_fields: ['primary'],
          agg_lateral: null,
          agg_weights: null,
          description: 'Test score (MEAN of scenario scores)',
        },
        {
          id: '18da02bc-6f0c-4cac-a080-ee03974d9a8d',
          key: 'primary',
          agg_func: null,
          agg_fields: null,
          agg_lateral: null,
          agg_weights: null,
          description: 'Scenario score (raw values)',
        },
        {
          id: '1de0f52c-ae47-4847-9148-97b8568952d3',
          key: 'punctuality',
          agg_func: 'MEAN',
          agg_fields: ['punctuality', 'success_rate'],
          agg_lateral: null,
          agg_weights: null,
          description: 'Test score (MEAN of scenario scores)',
        },
        {
          id: '33c1f8a3-5764-44cc-988b-0f9a53b7f4a1',
          key: 'primary',
          agg_func: 'NANMEAN',
          agg_fields: ['primary', 'primary', 'primary', 'punctuality', 'primary', 'primary', 'primary', 'primary'],
          agg_lateral: null,
          agg_weights: null,
          description: 'Benchmark score (MEAN of test scores)',
        },
        {
          id: '35d6834e-5f89-438b-adcc-326bbeda93e2',
          key: 'primary',
          agg_func: null,
          agg_fields: null,
          agg_lateral: null,
          agg_weights: null,
          description: 'Scenario score (raw values)',
        },
        {
          id: '63e93356-5033-451f-a3c2-cd607721661f',
          key: 'primary',
          agg_func: 'MEAN',
          agg_fields: ['primary'],
          agg_lateral: null,
          agg_weights: null,
          description: 'Test score (MEAN of scenario scores)',
        },
        {
          id: '67a19c4b-1873-4a44-8c07-e15d9ede1e78',
          key: 'primary',
          agg_func: 'MEAN',
          agg_fields: ['primary'],
          agg_lateral: null,
          agg_weights: null,
          description: 'Test score (MEAN of scenario scores)',
        },
        {
          id: '68a7aead-7408-4cfa-92ee-8c108e0bf5c7',
          key: 'primary',
          agg_func: null,
          agg_fields: null,
          agg_lateral: null,
          agg_weights: null,
          description: 'Scenario score (raw values)',
        },
        {
          id: '7f5b985b-d3a9-4e96-bd01-53ca1b73b256',
          key: 'primary',
          agg_func: null,
          agg_fields: null,
          agg_lateral: null,
          agg_weights: null,
          description: 'Scenario score (raw values)',
        },
        {
          id: 'a5c6d789-0c00-413d-b689-862806dd9b56',
          key: 'success_rate',
          agg_func: null,
          agg_fields: null,
          agg_lateral: null,
          agg_weights: null,
          description: 'Secondary scenario score (raw values): success_rate',
        },
        {
          id: 'c2a66425-186d-423b-b002-391c091b33c6',
          key: 'punctuality',
          agg_func: null,
          agg_fields: null,
          agg_lateral: null,
          agg_weights: null,
          description: 'Primary scenario score (raw values): punctuality',
        },
        {
          id: 'ca6afe0e-a91a-4683-b735-6069e6b0cd8a',
          key: 'primary',
          agg_func: 'MEAN',
          agg_fields: ['primary'],
          agg_lateral: null,
          agg_weights: null,
          description: 'Test score (MEAN of scenario scores)',
        },
        {
          id: 'de36c069-a167-4c22-8b30-3f93e6588507',
          key: 'primary',
          agg_func: null,
          agg_fields: null,
          agg_lateral: null,
          agg_weights: null,
          description: 'Scenario score (raw values)',
        },
        {
          id: 'e00859c3-d3e5-4bdf-9025-2030e22df317',
          key: 'primary',
          agg_func: 'MEAN',
          agg_fields: ['primary'],
          agg_lateral: null,
          agg_weights: null,
          description: 'Test score (MEAN of scenario scores)',
        },
        {
          id: 'e11b124d-af80-42b7-86d1-355ce9ee83c9',
          key: 'primary',
          agg_func: null,
          agg_fields: null,
          agg_lateral: null,
          agg_weights: null,
          description: 'Scenario score (raw values)',
        },
        {
          id: 'f0f478d6-436e-476f-be79-33d8c34f20c1',
          key: 'punctuality',
          agg_func: null,
          agg_fields: null,
          agg_lateral: null,
          agg_weights: null,
          description: 'Primary scenario score (raw values): punctuality',
        },
        {
          id: 'f56b119f-719d-4601-94ff-e511b2aaeeed',
          key: 'success_rate',
          agg_func: null,
          agg_fields: null,
          agg_lateral: null,
          agg_weights: null,
          description: 'Secondary scenario score (raw values): success_rate',
        },
        {
          id: 'fb1070a5-c929-4cd6-9723-1a5da97bfdf3',
          key: 'primary',
          agg_func: null,
          agg_fields: null,
          agg_lateral: null,
          agg_weights: null,
          description: 'Scenario score (raw values)',
        },
        {
          id: 'fcabd61d-91bc-45dc-8bf8-7aeb9724cb67',
          key: 'primary',
          agg_func: 'MEAN',
          agg_fields: ['primary'],
          agg_lateral: null,
          agg_weights: null,
          description: 'Test score (MEAN of scenario scores)',
        },
      ],
      results: [
        {
          key: 'punctuality',
          value: 0.9285714285714286,
          test_id: '98ceb866-5479-47e6-a735-81292de8ca65',
          scenario_id: '5a60713d-01f2-4d32-9867-21904629e254',
          submission_id: 'c3ce1c1c-f1ca-4ab4-8da9-b6dc43c588d0',
        },
        {
          key: 'punctuality',
          value: 1,
          test_id: '98ceb866-5479-47e6-a735-81292de8ca65',
          scenario_id: '0db72a40-43e8-477b-89b3-a7bd1224660a',
          submission_id: 'c3ce1c1c-f1ca-4ab4-8da9-b6dc43c588d0',
        },
        {
          key: 'success_rate',
          value: 1,
          test_id: '98ceb866-5479-47e6-a735-81292de8ca65',
          scenario_id: '0db72a40-43e8-477b-89b3-a7bd1224660a',
          submission_id: 'c3ce1c1c-f1ca-4ab4-8da9-b6dc43c588d0',
        },
        {
          key: 'success_rate',
          value: 1,
          test_id: '98ceb866-5479-47e6-a735-81292de8ca65',
          scenario_id: '5a60713d-01f2-4d32-9867-21904629e254',
          submission_id: 'c3ce1c1c-f1ca-4ab4-8da9-b6dc43c588d0',
        },
        null,
      ],
    } as SubmissionScoreSources
    const submissionId = 'c3ce1c1c-f1ca-4ab4-8da9-b6dc43c588d0'
    const aggregator = AggregatorService.getInstance()
    const scoring = aggregator.calculateSubmissionScore(sources, submissionId)
    expect(scoring.scorings[0].score).toBeCloseTo(0.9642857142857143)
  })
})
