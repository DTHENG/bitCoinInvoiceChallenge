package com.dtheng.bitcoin.util;

import java.io.IOException;

/**
 * @author Daniel Thengvall
 */
public class ShellUtil {

    private static final String LOCATION =
            ShellUtil.class.getProtectionDomain().getCodeSource().getLocation().getFile();

    public static Process getNewProcess(String shellScript, String arg1) throws IOException {
        ProcessBuilder pb = new ProcessBuilder("/bin/bash",
                LOCATION + shellScript, arg1);
        return pb.start();
    }

    public static Process getNewProcess(String shellScript, String arg1, String arg2) throws IOException {
        ProcessBuilder pb = new ProcessBuilder("/bin/bash",
                LOCATION + shellScript, arg1, arg2);
        return pb.start();
    }

    public static Process getNewProcess(String shellScript, String arg1, String arg2,
                                        String arg3) throws IOException {
        ProcessBuilder pb = new ProcessBuilder("/bin/bash",
                LOCATION + shellScript, arg1, arg2, arg3);
        return pb.start();
    }

    public static Process getNewProcess(String shellScript, String arg1, String arg2,
                                        String arg3, String arg4) throws IOException {
        ProcessBuilder pb = new ProcessBuilder("/bin/bash",
                LOCATION + shellScript, arg1, arg2, arg3, arg4);
        return pb.start();
    }

    public static Process getNewProcess(String shellScript, String arg1, String arg2,
                                        String arg3, String arg4, String arg5) throws IOException {
        ProcessBuilder pb = new ProcessBuilder("/bin/bash",
                LOCATION + shellScript, arg1, arg2, arg3, arg4, arg5);
        return pb.start();
    }
}
