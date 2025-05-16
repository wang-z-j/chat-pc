import { autoUpdater } from 'electron-updater'
import { BrowserWindow, dialog } from 'electron'
import { ProgressInfo } from 'builder-util-runtime'

class AppUpdater {
  private mainWindow: BrowserWindow

  constructor(mainWindow: BrowserWindow) {
    this.mainWindow = mainWindow
    this.configureAutoUpdater()
  }

  private configureAutoUpdater(): void {
    autoUpdater.autoDownload = false
    autoUpdater.allowPrerelease = false

    autoUpdater.checkForUpdates()

    // 更新进度处理
    autoUpdater.on('download-progress', (progress: ProgressInfo) => {
      this.mainWindow.webContents.send('update-progress', {
        percent: progress.percent.toFixed(1),
        bytesPerSecond: (progress.bytesPerSecond / 1024).toFixed(0),
        transferred: (progress.transferred / 1048576).toFixed(2),
        total: (progress.total / 1048576).toFixed(2)
      })
    })

    // 更新可用时通知
    autoUpdater.on('update-available', (info) => {
      dialog
        .showMessageBox(this.mainWindow, {
          type: 'info',
          buttons: ['下载并安装', '稍后提醒'],
          title: '发现新版本',
          message: `发现新版本 ${info.version}，是否立即更新？`,
          detail: '更新包含新功能和错误修复'
        })
        .then(({ response }) => {
          if (response === 0) {
            autoUpdater.downloadUpdate()
          }
        })
    })

    // 更新错误处理
    autoUpdater.on('error', (error) => {
      this.mainWindow.webContents.send('update-error', error.message)
    })

    // 更新准备完成
    autoUpdater.on('update-downloaded', () => {
      dialog
        .showMessageBox(this.mainWindow, {
          type: 'info',
          buttons: ['立即重启', '稍后'],
          title: '更新准备就绪',
          message: '新版本已下载完成，需要重启应用以完成安装'
        })
        .then(({ response }) => {
          if (response === 0) {
            autoUpdater.quitAndInstall()
          }
        })
    })
  }
}

export default AppUpdater
