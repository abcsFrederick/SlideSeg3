import slideseg3
import os
import sys
import argparse
from multiprocessing import Pool, Process
import timeit

def Run(params, filename, convert):
    slideseg3.run(params, filename, convert)

def main(convert):
    """
    Runs SlideSeg with the parameters specified in Parameters.txt
    :return: image chips and masks
    """
    params = slideseg3.load_parameters('Parameters.txt')
    print('running __main__ with parameters: {0}'.format(params))
    if not os.path.isdir(params["slide_path"]):
        path, filename = os.path.split(params["slide_path"])
        xpath, xml_filename = os.path.split(params["xml_path"])
        params["slide_path"] = path
        params["xml_path"] = xpath

        print('loading {0}'.format(filename))
        slideseg3.run(params, filename, convert)

    else:
        start = timeit.default_timer()
        # for filename in os.listdir(params["slide_path"]):
            # print(filename)
            # slideseg3.run(params, filename)
        print(params["cpus"])
        pool = Pool(int(params["cpus"]))

        for filename in os.listdir(params["slide_path"]):
            pool.apply_async(Run, args=(params, filename, convert,))
        pool.close()
        pool.join()

        print('get whole takes:',timeit.default_timer() - start)
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--mask", help="Only Convert mask to tiff(default is false)")
    args = parser.parse_args()
    main(args.mask)
