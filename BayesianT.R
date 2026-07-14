library(BayesFactor)

## ============================================================
## HAPPY conditions
## ============================================================

## --- CrossHappy ---
RightSecVisual2_CrossHappy <- c(8.8691, 14.1709, 0.0638, -12.8678, 2.6807, 2.8615,
                                15.3672, -7.0957, 2.3513, 0.0014, 2.0550, -6.7174,
                                1.0001, 1.6475, 13.4730, 0.0818, 9.7963)

## --- WithinHappy ---
LeftSecVisual1_WithinHappy <- c(16.2023, -20.5408, -15.4173, 2.2523, -6.7426, 7.7885,
                                -7.0770, 8.0481, -20.0411, 10.5039, 27.8926, 7.5825,
                                -23.9768, -3.0295, -2.8184, 12.3951, -4.3200)

RightSecVisual1_WithinHappy <- c(-8.8409, -1.8128, -17.4039, -20.3135, 1.6980, 18.0223,
                                 -13.2743, 8.9683, 9.5501, 2.8166, 19.5360, 21.1704,
                                 8.9788, 10.1932, -27.1177, 17.4633, -7.6017)

RightFFA_WithinHappy <- c(-2.9215, 14.8909, 4.3430, -8.1043, 14.5417, -3.7919,
                          -3.2393, 26.4278, 3.8857, -0.0921, 15.5058, 5.1803,
                          1.6112, -3.3217, -1.0089, 18.5023, -17.2262)

LeftVisualAssoc1_WithinHappy <- c(8.1783, 8.8317, 5.5262, 3.2089, 1.4891, -13.9277,
                                  -3.2278, 5.8036, 17.1710, 13.2720, 19.8393, 10.5667,
                                  -3.4203, 3.4436, -7.1233, 7.0273, 7.9415)

LeftSecVisual2_WithinHappy <- c(6.0381, 0.0389, 2.2530, 7.7554, 4.7490, -3.4342,
                                3.5085, -9.1367, 12.7187, 9.9316, 10.2435, 13.8681,
                                2.2700, 13.0279, 0.8467, 2.2611, -2.1189)

## ============================================================
## FEAR conditions
## ============================================================

## --- CrossFear ---
RightAntPFC_CrossFear <- c(9.1577, 10.1301, 1.9203, 13.8945, -6.3528, -7.7874, -0.6526,
                           -11.8470, 24.9521, 2.2036, -1.9257, -2.3573, -8.2076, 0.1476,
                           -2.4619, -24.8426, -10.7908)

Presuppmot_CrossFear <- c(4.4331, 0.3499, 6.0880, -4.4690, 10.7626, 10.7583, 4.4378,
                          -1.8205, 4.0100, -8.1180, -7.7027, 0.2081, -1.7062, -5.4616,
                          3.8575, 2.9864, 2.0646)

LeftVisualAssoc2_CrossFear <- c(-0.4188, 1.9043, 7.3367, -1.0883, 2.4763, -3.3263, 8.8962,
                                -7.6715, 2.7903, -3.1484, 6.0362, -1.6232, -3.9779, -8.2949,
                                16.0596, 1.1360, 1.4860)

LeftSupramGy_CrossFear <- c(-4.1357, 1.0759, 3.0656, 8.4531, -10.3207, 2.1956, -2.2410,
                            -9.3397, -1.9633, 2.6061, 0.6855, -3.8947, -1.1084, -5.4409,
                            -4.0522, -0.4574, 7.9126)

LeftFFA1_CrossFear <- c(-4.7703, -0.3482, 2.2199, 9.7962, -3.6017, -9.2793, 2.9637,
                        2.8977, 4.3850, -2.8104, 0.1177, 5.6621, 6.6979, -2.3885,
                        5.0690, -3.9819, 2.3413)

## --- WithinFear ---
LeftFFA2_WithinFear <- c(3.5073, 11.5101, 9.0574, -5.8525, -1.2650, 7.4811, 14.3104,
                         1.4000, 4.2685, 1.9299, -3.7289, -2.1495, -9.2406, -4.1348,
                         0.9647, -1.9126, -10.6761)

LeftSecVisual3_WithinFear <- c(9.9727, -2.0893, 18.6620, -2.1124, 4.0073, 6.5075, -2.0398,
                               2.9339, 7.7470, -2.9201, 0.7113, -1.7727, -3.2258, -11.1138,
                               6.8592, 4.7576, -1.1862)

LeftSecVisual4_WithinFear <- c(9.6728, 8.6680, 34.8505, 15.8528, -1.0377, 0.1151, -6.1313,
                               33.1139, 4.2076, -8.8240, 3.0013, 1.7326, -2.5269, -19.3659,
                               0.9747, 5.9849, -21.3375)

## ============================================================
## Run all 18 one-sample Bayesian t-tests against chance (0)
## ============================================================

results <- list(
  RightSecVisual2_CrossHappy    = ttestBF(x = RightSecVisual2_CrossHappy, mu = 0),
  LeftSecVisual1_WithinHappy    = ttestBF(x = LeftSecVisual1_WithinHappy, mu = 0),
  RightSecVisual1_WithinHappy   = ttestBF(x = RightSecVisual1_WithinHappy, mu = 0),
  RightFFA_WithinHappy          = ttestBF(x = RightFFA_WithinHappy, mu = 0),
  LeftVisualAssoc1_WithinHappy  = ttestBF(x = LeftVisualAssoc1_WithinHappy, mu = 0),
  LeftSecVisual2_WithinHappy    = ttestBF(x = LeftSecVisual2_WithinHappy, mu = 0),
  RightAntPFC_CrossFear         = ttestBF(x = RightAntPFC_CrossFear, mu = 0),
  Presuppmot_CrossFear          = ttestBF(x = Presuppmot_CrossFear, mu = 0),
  LeftVisualAssoc2_CrossFear    = ttestBF(x = LeftVisualAssoc2_CrossFear, mu = 0),
  LeftSupramGy_CrossFear        = ttestBF(x = LeftSupramGy_CrossFear, mu = 0),
  LeftFFA1_CrossFear            = ttestBF(x = LeftFFA1_CrossFear, mu = 0),
  LeftFFA2_WithinFear           = ttestBF(x = LeftFFA2_WithinFear, mu = 0),
  LeftSecVisual3_WithinFear     = ttestBF(x = LeftSecVisual3_WithinFear, mu = 0),
  LeftSecVisual4_WithinFear     = ttestBF(x = LeftSecVisual4_WithinFear, mu = 0)
)

results