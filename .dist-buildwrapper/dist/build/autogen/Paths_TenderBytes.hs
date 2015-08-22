module Paths_TenderBytes (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\Kavi\\AppData\\Roaming\\cabal\\bin"
libdir     = "C:\\Users\\Kavi\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-7.8.3\\TenderBytes-0.1"
datadir    = "C:\\Users\\Kavi\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-7.8.3\\TenderBytes-0.1"
libexecdir = "C:\\Users\\Kavi\\AppData\\Roaming\\cabal\\TenderBytes-0.1"
sysconfdir = "C:\\Users\\Kavi\\AppData\\Roaming\\cabal\\etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "TenderBytes_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "TenderBytes_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "TenderBytes_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "TenderBytes_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "TenderBytes_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
