-- Аналог множественного оператора В (IN) из 1С: [SELECT * FROM Т WHERE (Т.a, Т.b) IN (SELECT Т'.a, Т'.b FROM Т')]

SELECT * FROM T WHERE EXISTS (SELECT 1 FROM
                              T' WHERE T.a = T'.a AND
                                       T.b = T'.b)
