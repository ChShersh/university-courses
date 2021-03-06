package com.ifmo.ml.reg.dividers;

import java.util.List;

public interface Divider<T> {
    int iterations();
    int getParts();
    void divide(int i);
    List<T> getTrainingSamples();
    List<T> getTestingSamples();
}
