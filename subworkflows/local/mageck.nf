
include { MAGECK_TEST } from "../../modules/local/mageck/test"
include { MAGECK_MLE  } from "../../modules/local/mageck/mle"

workflow MAGECK {
    take:
        ch_count

    main:
        MAGECK_TEST(ch_count)

        if (params.design_matrix) {
            MAGECK_MLE(ch_count, file(params.design_matrix, checkIfExists: true))
            mle_gene = MAGECK_MLE.out.gene
            mle_sgrna = MAGECK_MLE.out.sgrna
        } else {
            mle_gene = null
            mle_sgrna = null
        }

    emit:
        test_gene  = MAGECK_TEST.out.gene
        test_sgrna = MAGECK_TEST.out.sgrna
        mle_gene   = mle_gene
        mle_sgrna  = mle_sgrna

}
