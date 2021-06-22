Code based on "Tunçgenç, B., Pacheco, C., Rochowiak, R., Nicholas, R.,
Rengarajan, S., Zou, E., ... & Mostofsky, S. H. (2021). 
Computerized Assessment of Motor Imitation as a Scalable Method for Distinguishing 
Children With Autism. Biological Psychiatry: Cognitive Neuroscience and Neuroimaging, 6(3), 321-328."

Main scripts:
- CAMI_training.m: Learns coefficients for linear combination of DTW-based features that maximize correlation 
                   between predicted CAMI scores and Human Based Observation (HOC) scores for multiple sequences
                   at the time
- CAMI_inference.m: Performs inference of CAMI scores based on the parameters reported in published paper. 
