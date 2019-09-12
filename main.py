import slideseg3
import os
import sys

def main():
    """
    Runs SlideSeg with the parameters specified in Parameters.txt
    :return: image chips and masks
    """
    print(sys.version)
    def str2bool(value):
        return value.lower() in ("true", "yes", "1")

    params = slideseg3.load_parameters('Parameters.txt')
    print('running __main__ with parameters: {0}'.format(params))

    if not os.path.isdir(params["slide_path"]):
        path, filename = os.path.split(params["slide_path"])
        xpath, xml_filename = os.path.split(params["xml_path"])
        params["slide_path"] = path
        params["xml_path"] = xpath

        print('loading {0}'.format(filename))
        slideseg3.run(params, filename)

    else:
        for filename in os.listdir(params["slide_path"]):
            slideseg3.run(params, filename)

if __name__ == "__main__":
    main()
