import os
def changeParameters(args):
  with open('Parameters.txt','r') as Parameters:
    with open('ParametersNew.txt','w') as ParametersNew:
      lines = Parameters.readlines()
      for line in lines:
        line = line.strip()
        if not line or line.startswith('#'):
          continue
        option = line.partition(":")[0]
        value = line.partition(":")[2]
        value = value.partition("#")[0].strip()
        for key, newValue in vars(args).items():
          if option == key:
            line = line.replace(value, newValue)
        ParametersNew.write(line+'\n')
  os.remove("Parameters.txt")
  os.rename("ParametersNew.txt", "Parameters.txt")
if __name__ == '__main__':
  import argparse
  import sys

  parser = argparse.ArgumentParser(add_help=False)
  parser.add_argument('--slide_path', required=True)
  parser.add_argument('--xml_path', required=True)
  parser.add_argument('--output_dir', required=True)
  parser.add_argument('--cpus', required=True)
  args, argv = parser.parse_known_args()
  changeParameters(args)