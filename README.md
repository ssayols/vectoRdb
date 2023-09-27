# vectoRdb

A (toy) vector database made in R.

## Details

DNA bases [A, C, G, T] are encoded as numbers [1, 2, 3, 4], respectively, in vectors of k-mers.

The search feature is based on the Cosine similarity between the query vector and the vectors stored in the database.

All possible trade-offs are made in favour of simplicity:

  * Everything is stored in memory in a `list()`
  * Every time a search query is made, the whole database space is searched (a cosine similarity is calculated for every vector stored in the db)
  * Single-threaded (altthough multicore is trivial to implement at least in the `search()` function)

Therefore, no caching of computed cosines. And the size of the database is limited by memory size.

Regarding caching of computed cosines: if the database stores 10-mers of DNA values, the whole search-space could be cached in only 4^10 == ~1M distances values (~10M in RAM). For 20-mers (default seed length in bowtie 2), 4^20 which is a bit more than a thousand billion values (about 1TB in RAM). NOTE: namespace limited to [A, C, G, T] only (no eg. N or other IUPAC characters).

## Further reading

Meta's [FAISS](https://faiss.ai/), and some of FAISS foundational reasearch papers:
  * The inverted file from "[Video google: A text retrieval approach to object matching in videos.](http://ieeexplore.ieee.org/abstract/document/1238663/)", Sivic & Zisserman, ICCV 2003. This is the key to non-exhaustive search in large datasets. Otherwise all searches would need to scan all elements in the index, which is prohibitive even if the operation to apply for each element is fast
