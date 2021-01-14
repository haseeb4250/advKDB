/sym.q contains the schemas for tick.q

trade: ([] time:`timespan$(); sym:`symbol$(); price:`float$(); size:`long$());
quote: ([] time:`timespan$(); sym:`symbol$(); bidSize:`long$(); askSize:`long$(); bidPrice:`float$(); askPrice:`float$());
agrTab: ([] time:`timespan$(); sym:`symbol$(); maxPrice:`float$(); minPrice:`float$(); tradeVol:`long$(); maxBid:`long$(); minAsk:`long$());
