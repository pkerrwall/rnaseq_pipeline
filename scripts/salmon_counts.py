import pandas as pd
import os,sys
pd.set_option('display.float_format', lambda x: '%.2f' % x)

# pipeline is for paired-end sequences per sample
if len(sys.argv) < 1:
    print("usage: python salmon_counts.py <aln_dir>")
    sys.exit(1)

# pipeline for paired-end reads
aln_dir = sys.argv[1]

# get list of directories in salmon_dir
dirs = [x for x in os.listdir(aln_dir) if os.path.isdir(os.path.join(aln_dir, x))]
dirs.sort()
print(dirs)

df = pd.DataFrame(columns=['Name'])
for dir in sorted(dirs, key=lambda x: (x.casefold(), x.swapcase())):
    print(f"{dir}")
    this_df = pd.read_csv(f"{aln_dir}/{dir}/quant.genes.sf", sep='\t')
    this_df = this_df[['Name','NumReads']]
    this_df.rename(columns={'NumReads':f"{dir}"}, inplace=True)
    #print(this_df.head(2))
    df = df.merge(this_df, how='outer', on='Name')

df.rename(columns={'Name':'gene_id'}, inplace=True)

# replace NaN with 0
df.fillna(0, inplace=True)

# remove _salmon_quant from all column names
df.columns = [x.replace('_salmon_quant','') for x in df.columns]
#print(df.head())

df = df.sort_values(by='gene_id')
#df = df.astype(int)
df = df.round(2)
df.to_csv(aln_dir + '/salmon.gene_counts.tsv', sep='\t', index=False)
df.to_csv(aln_dir + '/salmon.gene_counts.csv', sep=',', index=False)