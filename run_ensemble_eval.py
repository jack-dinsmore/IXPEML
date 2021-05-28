'''
Wrapper file to apply an ensemble of NNs to square track datasets.
'''

from util.net_test import *
import os, sys
import argparse
from util.definitions import ensembles

parser = argparse.ArgumentParser()
parser.add_argument('save_name', type=str,
                    help='Save Net FoV results in Pandas dataframe with this name')
parser.add_argument('--ensemble', type=str, default="bessel_rand",
                    help='Which network ensemble to use: Ensemble prediction or single prediction') #choices=["bessel_rand","bessel_rand_small","heads_only","tailvpeak","energy", "flat_weight","heads_only_new","heads_only_newO1","tailvpeak_newO1"],
parser.add_argument('--data_list', type=str, nargs='+',
                    help='List of Data to evaluate on')
parser.add_argument('--local_rank', type=int,
                    help='List of Data to evaluate on')
parser.add_argument('--batch_size', type=int, default=2048,
                    help='Batch size to use for NN evaluation, lower if out of memory error. Maximum possible size should be used to maximize speed.')
parser.add_argument('--nworkers', type=int, default=1,
                    help='Number cpu processes that load data to gpus, should always be <= ngpus and <= ncpus or it may slow things down.')
parser.add_argument('--datatype', type=str, default="meas", choices=["meas","sim"],
                    help='Simulated or Measured track data, should just use default (meas).')
parser.add_argument('--stokes_correct', type=float, choices=[2.0, 2.3, 2.7, 3.1, 3.7, 5.9], default=None,
                    help='Whether to correct measured tracks for spurious modulation (incomplete).')
args = parser.parse_args()


def main():
    net_list = ensembles[args.ensemble]

    print("Evaluating using ensemble: \n", net_list)
    print("\n {} NNs in the ensemble \n".format(len(net_list)))

    t = NetTest(nets=net_list, datasets=args.data_list, n_nets=len(net_list), datatype=args.datatype,
                save_table=args.save_name, stokes_correct=args.stokes_correct, batch_size=args.batch_size,
                nworkers=args.nworkers)
    t.ensemble_predict()


if __name__ == '__main__':
    main()



