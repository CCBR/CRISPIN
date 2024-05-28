include { BAGEL_FOLD_CHANGE      } from '../../modules/local/bagel/fold_change'
include { BAGEL_BAYES_FACTOR     } from '../../modules/local/bagel/bayes_factor'
include { BAGEL_PRECISION_RECALL } from '../../modules/local/bagel/precision_recall'

workflow BAGEL {
    take:
        ch_count

    main:
        BAGEL_FOLD_CHANGE(ch_count)
        BAGEL_BAYES_FACTOR(BAGEL_FOLD_CHANGE.out.fc)
        BAGEL_PRECISION_RECALL(BAGEL_BAYES_FACTOR.out.bf)

    emit:
        fold_change = BAGEL_FOLD_CHANGE.out.fc
        count_norm = BAGEL_FOLD_CHANGE.out.count_norm
        bayes_factor = BAGEL_BAYES_FACTOR.out.bf
        prec_rec = BAGEL_PRECISION_RECALL.out.pr
}
